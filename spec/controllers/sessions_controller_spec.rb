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


describe SessionsController do
  controller_name :sessions

  should_route :get, '/session', :controller =>'sessions', :action=>'show'
  should_route :post, '/session', :controller =>'sessions', :action=>'create'
  should_route :delete, '/session', :controller =>'sessions', :action=>'destroy'
  should_filter_params :password

  describe 'GET /session' do
    before { get :show }

    should_render_template 'sessions/show'
  end

  describe 'POST /session' do
    before { Person.me }

    describe '(no credentials)' do
      before { post :create }

      it('should have no authenticated user in session')      { authenticated.should be_nil }
      it('should have no error message in flash')             { flash.should be_empty }
      should_redirect_to                                      { session_path }
    end

    describe '(wrong credentials)' do
      before { post :create, :login=>Person.me.login, :password=>'wrong' }

      it('should have no authenticated user in session')      { authenticated.should be_nil }
      it('should have error message in flash')                { flash[:error].should match(/no account/i) }
      should_redirect_to                                      { session_path }
    end

    describe '(valid credentials)' do
      before { post :create, :login=>Person.me.login, :password=>'secret' }

      it('should store authenticated user in session')        { authenticated.should == Person.me }
      it('should clear flash')                                { flash.should be_empty }
      should_redirect_to                                      { root_path }
    end

    describe '(valid credentials and return url)' do
      before { post :create, { :login=>Person.me.login, :password=>'secret' }, { :return_url=>'http://return_url' } }

      it('should store authenticated user in session')        { authenticated.should == Person.me }
      it('should clear return url from session')              { session[:return_url].should be_nil }
      should_redirect_to                                      { 'http://return_url' }
    end

  end


  describe 'DELETE /session' do
    before do
      @controller.instance_eval do
        @current_session = ApplicationController::UserSession.new
        @current_session.should_receive(:destroy)
        @authenticated = Person.me
      end
      delete :destroy
    end

    it('should have no authenticated user in session')  { authenticated.should be_nil }
    should_redirect_to                                  { root_path }
  end

end
