# Singleshot  Copyright (C) 2009-2009  Intalio, Inc
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


class ApplicationController < ActionController::Base #:nodoc:

  helper :all # include all helpers, all the time

  # Returns currently authenticated person.
  attr_reader :authenticated
  helper_method :authenticated

private

  # --- Authentication/Security ---

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation

  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery

  before_filter :authenticate
  # Authentication filter enabled by default since most resources are guarded.
  def authenticate
    auth_session = AuthSession.find
    @authenticated = auth_session && auth_session.person
    if @authenticated
      I18n.locale = @authenticated.locale.to_sym if @authenticated.locale
      Time.zone = @authenticated.timezone
    elsif request.format.html?
      session[:return_url] = request.url
      redirect_to session_url
    else
      request_http_basic_authentication
    end
  end

  helper_method :sidebar
  def sidebar
    ApplicationHelper::Sidebar.new @activities, @templates, @notifications
  end

end
