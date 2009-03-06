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


# == Schema Information
# Schema version: 20090206215123
#
# Table name: webhooks
#
#  id          :integer         not null, primary key
#  task_id     :integer         not null
#  event       :string(255)     not null
#  url         :string(255)     not null
#  http_method :string(255)     not null
#  enctype     :string(255)     not null
#  hmac_key    :string(255)
#
describe Webhook do
  subject { Webhook.make }

  it { should belong_to(:task, Task) }

  it { should have_attribute(:event, :string, :null=>false) }
  it { should validate_presence_of(:event) }

  it { should have_attribute(:url, :string, :null=>false) }
  it { should validate_presence_of(:url) }

  it { should have_attribute(:http_method, :string, :null=>false) }
  it { should validate_presence_of(:http_method) }
  it('should have http_method=post by default') { subject.http_method.should == 'post' }
  it { should allow_mass_assigning_of(:method) }

  it { should have_attribute(:enctype, :string, :null=>false) }
  it { should validate_presence_of(:enctype) }
  it('should have enctype=url-encoded by default') { subject.enctype.should == Mime::URL_ENCODED_FORM.to_s }

  it { should have_attribute(:hmac_key, :string) }
  it { should_not validate_presence_of(:hmac_key) }

end