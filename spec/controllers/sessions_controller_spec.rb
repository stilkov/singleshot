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
  describe 'GET /session' do
    before { get :show }

    should_render_template 'sessions/show'
  end


  should_route :post, '/session', :controller =>'sessions', :action=>'create'
  describe 'POST /session' do
    before { Person.me }

    describe '(no credentials)' do
      before { post :create }

      should_not_login
      should_render_template 'sessions/show'
    end

    describe '(wrong credentials)' do
      before { post :create, :login=>Person.me.login, :password=>'wrong' }

      should_not_login
      should_render_template 'sessions/show'
    end

    describe '(valid credentials)' do
      before { post :create, :login=>Person.me.login, :password=>'secret' }

      should_login { Person.me }
      should_redirect_to                                      { root_path }
    end

    describe '(valid credentials and return url)' do
      before { post :create, { :login=>Person.me.login, :password=>'secret' }, { :return_url=>'http://return_url' } }

      should_login { Person.me }
      should_redirect_to                                      { 'http://return_url' }
    end

  end


  should_route :delete, '/session', :controller =>'sessions', :action=>'destroy'
  describe 'DELETE /session' do
    before do
      AuthSession.should_receive(:find).and_return do
        AuthSession.new(Person.me).tap(&:save)
      end
      delete :destroy
    end

    should_not_login
    should_redirect_to                                  { root_path }
  end


  def login(&block)
    simple_matcher "login" do |given, matcher|
      run_action!
      if block
        expected = block.call
        actual = controller.session[:person_credentials_id] && Person.find_by_id(controller.session[:person_credentials_id])
        matcher.failure_message = "expected #{expected.inspect} but got #{actual.inspect}"
        actual == expected
      else
        matcher.failure_message = "expected authenticated person"
        controller.session[:person_credentials_id]
      end
    end
  end

end
