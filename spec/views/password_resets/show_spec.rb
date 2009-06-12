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

describe '/password_resets/show' do
  before do
    controller.allow_forgery_protection = true
    assigns[:person] = Person.make.tap { |p| p.perishable_token = '789' }
    render '/password_resets/show'
  end

  it 'should render login form' do
    response.should have_tag('form.login') do
      with_tag 'form[method=post][action=?]', password_reset_path('789') do
        with_tag 'fieldset' do
          with_tag 'label[for=password]', "Password:"
          with_tag 'input[name=password][type=password][title=Your password is case sensitive]'
          with_tag 'label[for=password_confirmation]', "Confirmation:"
          with_tag 'input[name=password_confirmation][type=password][title=Once more, confirm your password]'
          with_tag 'input[type=submit][value=Change password]'
        end
      end
    end
  end

  should_have_tag 'form.login input[name=password].auto_focus'
  should_have_tag 'form.login input[name=authenticity_token][type=hidden]'
  should_not_have_tag 'p.error'
end

describe '/password_resets/show with error message' do
  before do
    controller.allow_forgery_protection = true
    assigns[:person] = Person.make
    assigns[:person].update_attributes :password=>'newsecret'
    render '/password_resets/show'
  end

  should_have_tag 'form.login fieldset div.error', "Password doesn't match confirmation"
end

