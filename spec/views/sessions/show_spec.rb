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


require File.dirname(__FILE__) + '/../helpers'

describe '/sessions/show' do
  before do
    controller.allow_forgery_protection = true
    Authlogic::Session::Base.controller = Authlogic::TestCase::MockController.new
    assigns[:auth_session] = AuthSession.new
    render '/sessions/show'
  end

  it 'should render login form' do
    response.should have_tag('form.login') do
      with_tag 'form[method=post][action=?]', session_url do
        with_tag 'fieldset' do
          with_tag 'label[for=login]', "Username:"
          with_tag 'input[name=login][type=text][title=Your username]'
          with_tag 'label[for=password]', "Password:"
          with_tag 'input[name=password][type=password][title=Your password is case sensitive]'
          with_tag 'label', "Remember me on this computer"
          with_tag 'input[name=remember_me][type=checkbox][value=1][checked]'
          with_tag 'input[type=submit][value=Login]'
          with_tag 'a[href=?]', password_resets_path, "Help, I lost my password!"
        end
      end
    end
  end

  should_have_tag 'form.login input[name=login].auto_focus'
  should_have_tag 'form.login input[name=authenticity_token][type=hidden]'
  should_not_have_tag 'p.error'
end

describe '/sessions/show with error message' do
  before do
    controller.allow_forgery_protection = true
    Authlogic::Session::Base.controller = Authlogic::TestCase::MockController.new
    assigns[:auth_session] = AuthSession.new
    assigns[:auth_session].errors.add_to_base "Error message"
    render '/sessions/show'
  end

  should_have_tag 'form.login fieldset div.error', "Error message"
end
