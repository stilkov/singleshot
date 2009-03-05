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
# Table name: activities
#
#  id         :integer         not null, primary key
#  person_id  :integer         not null
#  task_id    :integer         not null
#  name       :string(255)     not null
#  created_at :datetime        not null
#
describe Activity do

  describe 'new' do
    subject { Activity.make_unsaved }

    it { should belong_to(:person, Person) }
    it { should validate_presence_of(:person) }

    it { should belong_to(:task, Task) }

    it { should have_attribute(:name, :string, :null=>false) }
    it { should validate_presence_of(:name) }
    it { should have_attribute(:created_at, :datetime, :null=>false) }
  end

  describe 'existing' do
    subject { Activity.make }

    it { should be_readonly }
  end

  describe 'date' do
    subject { Activity.make }

    it('should return created_at date') { subject.date.should == subject.created_at.to_date }
  end

  describe 'for scope'

  describe 'default scope' do
    subject { Activity.send(:scope, :find) }

    it('should return activities by reverse chronological order') { subject[:order].split(/,\s/).should == ['created_at desc', 'id desc'] }
    it('should only affect selection order') { subject.except(:order).should be_empty }
  end

  describe 'since scope' do
    subject { Activity.since(@date = Date.yesterday).proxy_options }

    it('should select all activities created since given date') { subject[:conditions].should == ['created_at >= ?', @date] }
    it('should only affect selection criteria') { subject.except(:conditions).should be_empty }
  end

end
