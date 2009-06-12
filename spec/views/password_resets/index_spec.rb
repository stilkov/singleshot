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

describe '/password_resets/index' do
  describe '(no errors)' do
    before { render '/password_resets/index' }

    it 'should ask you to enter email address' do
      response.should have_tag('form.login') do
        with_tag 'form[method=post][action=?]', password_resets_path do
          with_tag 'fieldset' do
            with_tag 'label[for=email]', "Email:"
            with_tag 'input[name=email][type=text][title=Your email address]'
            with_tag 'input[type=submit][value=Recover]'
          end
        end
      end
    end
  end

  describe '(with errors)' do
    before do
      assigns[:error] = "Error message"
      render '/password_resets/index'
    end
    should_have_tag 'form.login fieldset div.error', "Error message"
  end

end


