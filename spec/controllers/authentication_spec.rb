# Singleshot  Copyright (C) 2008-2009  Intalio, Inc
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


require File.dirname(__FILE__) + '/helpers'


class AuthenticationTestController < ApplicationController
  self.allow_forgery_protection = true

  def index
    render :nothing=>true
  end

  def feed
    render :nothing=>true
  end
end

describe AuthenticationTestController do
  before { @person = Person.make(:email=>'john@example.com', :locale=>'tlh', :timezone=>-11) }

  should_filter_params :password, :password_confirmation

  describe 'unauthenticated request' do
    describe '(HTML)' do
      before { get :index }
      should_redirect_to                          { session_path }
      it('should store return URL in session')    { session[:return_url].should == request.url }
      it('should reset I18n locale')              { I18n.locale.should == :en }
      it('should reset TimeZone')                 { Time.zone.utc_offset == 0 }
    end

    describe '(XML)' do
      before { get :index, :format=>:xml }
      should_respond_with 401
    end

    describe '(JSON)' do
      before { get :index, :format=>:json }
      should_respond_with 401
    end

    describe '(Atom)' do
      before { get :index, :format=>:atom }
      should_respond_with 401
    end
  end

  describe 'session authentication' do
    describe '(invalid session)' do
      before { get :index, nil, :authenticated=>'foo' }
      should_redirect_to { session_path }
    end

    describe '(authenticated)' do
      before do
        authenticate @person
        get :index
      end
      should_respond_with 200
      should_authenticate_account
      it('should set I18n.locale')                  { I18n.locale.should == :tlh }
      it('should set Time.zone')                    { Time.zone.should == ActiveSupport::TimeZone[-11] }
    end
  end


  describe 'HTTP Basic authentication' do
    describe '(with credentials)' do
      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@person.login, 'secret')
        get :index
      end

      should_respond_with 200
      should_authenticate_account
      it('should set I18n.locale')                  { I18n.locale.should == :tlh }
      it('should set Time.zone')                    { Time.zone.should == ActiveSupport::TimeZone[-11] }
    end

    describe '(with invalid credentials)' do
      before do
        @request.env['HTTP_ACCEPT'] = Mime::XML.to_s
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@person.login, 'wrong')
        get :index
      end

      should_respond_with 401
    end
  end
  

  describe 'access key authentication' do
    before { rescue_action_in_public! }

    describe '(Atom)' do
      before do
        @request.env['HTTP_ACCEPT'] = Mime::ATOM.to_s
        get :feed, :access_key=>@person.single_access_token
      end
      should_respond_with 200
      should_authenticate_account
    end

    describe '(ICS)' do
      before do
        @request.env['HTTP_ACCEPT'] = Mime::ICS.to_s
        get :feed, :access_key=>@person.single_access_token
      end
      should_respond_with 200
      should_authenticate_account
    end

    describe '(HTML)' do
      before do
        @request.env['HTTP_ACCEPT'] = Mime::HTML.to_s
        get :feed, :access_key=>@person.single_access_token
      end
      should_redirect_to { session_path }
    end

    describe '(invalid access key)' do
      before do
        @request.env['HTTP_ACCEPT'] = Mime::ATOM.to_s
        get :feed, :access_key=>'wrong'
      end
      should_respond_with 401
    end
  end


  describe 'forgery protection' do
    before do
      rescue_action_in_public!
    end

    it 'should apply when accessing from browser' do
      request.env['CONTENT_TYPE'] = Mime::URL_ENCODED_FORM.to_s
      post :index, {}, :authenticated=>@person
      should respond_with(422)
    end

    it 'should not apply when using XML' do
      request.env['CONTENT_TYPE'] = Mime::XML
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@person.login, 'secret')
      post :index, {}
      should respond_with(200)
    end

    it 'should not apply when using JSON' do
      request.env['CONTENT_TYPE'] = Mime::JSON
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@person.login, 'secret')
      post :index, {}
      should respond_with(200)
    end
  end


  def authenticate_account
    simple_matcher 'authenticate account' do |given|
      controller.send(:authenticated) == @person
    end
  end
end
