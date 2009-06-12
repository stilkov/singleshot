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


describe PasswordResetsController do

  should_route :get, '/password_resets', :controller =>'password_resets', :action=>'index'
  describe :get=>:index do
    should_render_template 'password_resets/index'
  end


  should_route :post, '/password_resets', :controller =>'password_resets', :action=>'create'
  describe :post=>:create do
    before { Person.me }

    describe '(no email)' do
      params :email=>''
      should_assign_to :error, :with=>"Please enter your email address"
      should_render_template 'password_resets/index'
    end

    describe '(no such email)' do
      params :email=>'foo@example.com'
      should_assign_to :error, :with=>"No account with this email address"
      should_render_template 'password_resets/index'
    end

    describe '(valid email)' do
      params :email=>'john@example.com'
      should_set_the_flash :success, :to=>"We sent you instructions how to reset your password. Check your email and follow the instructions."
      it('should change perishable token') { lambda { run_action! }.should change { Person.last.perishable_token } }
      it('should send email') { lambda { run_action! }.should change { ActionMailer::Base.deliveries.size } }
      should_redirect_to { root_url }
    end

    describe 'email' do
      before do
        Person.me
        Person.update_all :perishable_token=>'789'
        Mailer.deliver_password_reset Person.me
      end
      subject { ActionMailer::Base.deliveries.last }

      should_have_subject "Instructions for resetting your password"
      should_deliver_to   "john@example.com"
      should_have_header  'from', "Notifications <notifications@example.com>"
      should_have_header  'reply-to', "Do not reply <noreply@example.com>"
      should_have_body_text "http://example.com/password_resets/789"
    end
  end


  should_route :get, '/password_resets/56', :controller=>'password_resets', :action=>'show', :id=>'56'
  describe :get=>:show do
    before do
      Person.make
      Person.update_all :perishable_token=>56
    end
    
    describe '(invalid token)' do
      params :id=>57
      should_set_the_flash :error, :to=>"If you are having issues, try copying and pasting the URL from your email into your browser or restarting the reset password process."
      should_redirect_to { root_url }
    end

    describe '(valid token)' do
      params :id=>56
      should_render_template 'password_resets/show'
    end
  end


  should_route :put, '/password_resets/56', :controller=>'password_resets', :action=>'update', :id=>'56'
  describe :put=>:update do
    before do
      @person = Person.make
      Person.update_all 'perishable_token = 56', :id=>@person.id
    end
    
    describe '(invalid token)' do
      params :id=>57
      should_set_the_flash :error, :to=>"If you are having issues, try copying and pasting the URL from your email into your browser or restarting the reset password process."
      should_redirect_to { root_url }
    end

    describe '(no password)' do
      params :id=>56, :password=>''
      should_render_template 'password_resets/show'
    end

    describe '(no confirmation)' do
      params :id=>56, :password=>'newsecret'
      should_render_template 'password_resets/show'
    end

    describe '(new password)' do
      params :id=>56, :password=>'newsecret', :password_confirmation=>'newsecret'

      it('should change perishable_token')  { lambda { run_action! }.should change { @person.reload.perishable_token } }
      it('should change password')          { lambda { run_action! }.should change { @person.reload.valid_password?('newsecret') } }
      it('should login person')             { lambda { run_action! }.should change { session[:person_credentials_id] }.to(@person.id) }
      should_set_the_flash :success, :to=>"You successfully changed your password."
      should_redirect_to                    { root_url }
    end

  end

end
