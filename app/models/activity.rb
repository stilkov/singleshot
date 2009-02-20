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


# Activity stream records who did what to which task. Activities are logged
# when updating at task.
#
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
class Activity < ActiveRecord::Base

  # Activity associated with a task.
  belongs_to :task

  # Activity associated with a person.
  belongs_to :person
  validates_presence_of :person
  
  symbolize :name
  validates_presence_of :name

  attr_readable :name, :task, :person, :created_at

  def readonly? #:nodoc:
    !new_record?
  end

  # Returns activities from all tasks associated with this stakeholder.
  named_scope :for, lambda { |person|
    { :joins=>'JOIN stakeholders AS involved ON involved.task_id=activities.task_id',
      :conditions=>["involved.person_id=?", person.id], :include=>[:task, :person],
      :order=>'activities.created_at desc' } }
=begin
  # Returns activities for a range of dates (from..to) or from a given date to today.
  named_scope :during, lambda { |arg|
    range = case arg
    when Date, Time; arg.to_time.in_time_zone.beginning_of_day..Time.current.end_of_day
    when Range;      arg.first.to_time.in_time_zone.beginning_of_day..arg.last.to_time.in_time_zone.end_of_day
    end
    { :conditions=>{ :created_at=>range } } }

  # Eager loads all activities and their dependents (task, person).
  named_scope :with_dependents, :include=>[:task, :person]
=end

  # Returns activities by recently added order.
  default_scope :order=>'created_at desc'

end
