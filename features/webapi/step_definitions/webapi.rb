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


require 'rack'

Given /^I am authenticated$/ do
  Given "I am authenticated as me"
end

Given /^I am authenticated as (.*)$/ do |person|
  Given "the person #{person}"
  basic_auth person, 'secret'
end

When /^I login/ do
  Given "the person me"
  basic_auth 'me', 'secret'
end

class RackApp
  def self.instance
    @instance ||= new
  end

  def self.start
    Thread.new do
      Rack::Handler::WEBrick.run instance, :Port=>1234, :Logger=>WEBrick::Log.new(nil, WEBrick::Log::ERROR)
    end
  end

  def initialize
    @requests = []
  end

  attr_reader :requests

  def call(env)
    requests << { :url=>env['REQUEST_URI'], :method=>env['REQUEST_METHOD'], :enctype=>env['CONTENT_TYPE'] }
    [ '200', {}, 'OK' ]
  end
end

RackApp.start