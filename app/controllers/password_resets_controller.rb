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


class PasswordResetsController < ApplicationController #:nodoc:

  skip_before_filter :authenticate
  before_filter :use_perishable_token, :only=>[:show, :update]

  def index
  end

  def create
    if person = Person.find_by_email(params[:email])
      person.reset_perishable_token!
      Mailer.deliver_password_reset person
      flash[:success] = "We sent you instructions how to reset your password. Check your email and follow the instructions."
      redirect_to root_url
    else
      @error = params[:email].blank? ? t('password_resets.errors.noemail') : t('password_resets.errors.noaccount')
      render :action=>:index
    end
  end

  def show
  end

  def update
    if !params[:password].blank? && @person.update_attributes(params)
      AuthSession.create(@person)
      flash[:success] = "You successfully changed your password."
      redirect_to root_url
    else
      render :action=>:show
    end
  end

private

  def use_perishable_token
    unless @person = Person.find_using_perishable_token(params[:id])
      flash[:error] = "If you are having issues, try copying and pasting the URL from your email into your browser or restarting the reset password process."
      redirect_to root_url
    end
  end

end
