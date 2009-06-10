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
#
# Table name: people
#
#  id                  :integer(4)      not null, primary key
#  fullname            :string(255)     not null
#  email               :string(255)     not null
#  locale              :string(5)
#  timezone            :integer(4)
#  created_at          :datetime
#  updated_at          :datetime
#  login               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#
describe Person do
  subject { Person.make }

  should_have_attribute :login
  should_have_column :login, :type=>:string
  should_allow_mass_assignment_of :login
  should_validate_uniqueness_of :login, :case_sensitive=>false
  it ('should set login from email if unspecified') { subject.valid? ; subject.login.should == 'john.smith' }

  should_have_attribute :email
  should_have_column :email, :type=>:string
  should_allow_mass_assignment_of :email
  should_validate_presence_of :email, :message=>"I need a valid e-mail address."
  should_validate_uniqueness_of :email, :case_sensitive=>false
  should_validate_email :email

  should_have_attribute :fullname
  should_have_column :fullname, :type=>:string
  should_allow_mass_assignment_of :fullname
  it ('should set fullname from email if unspecified') { subject.valid? ; subject.fullname.should == 'John Smith' }

  should_have_attribute :timezone
  should_have_column :timezone, :type=>:integer
  should_allow_mass_assignment_of :timezone
  should_not_validate_presence_of :timezone

  should_have_attribute :locale
  should_have_column :locale, :type=>:string
  should_allow_mass_assignment_of :locale
  should_not_validate_presence_of :locale

  should_have_attribute :crypted_password
  should_have_attribute :password_salt
  should_have_attribute :persistence_token
  should_have_attribute :single_access_token
  should_have_attribute :perishable_token
  should_allow_mass_assignment_of :password, :password_confirmation
  should_not_allow_mass_assignment_of :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token

  should_have_attribute :created_at
  should_have_column :created_at, :type=>:datetime
  should_have_attribute :updated_at
  should_have_column :updated_at, :type=>:datetime

  describe '.identify' do
    subject { Person.make }

    it('should return same Person as argument')   { should identify(subject) }
    it('should return person with same login')    { should identify(subject.login) }
    it('should fail if no person identified')     { should_not identify('missing') }
    
    # Expecting Person.identify(login) to return subject
    def identify(login)
      simple_matcher("identify '#{login}'") { |given, matcher| wrap_expectation(matcher) { Person.identify(login) == subject } }
    end
  end

  # TODO: this needs to be generalized, as it now applies to both tasks and templates
  describe '.tasks' do

    describe '.create' do
      before  { @bob = Person.named('bob') }
      subject { @bob.tasks.create(:title=>'foo') }

      it('should save task')                                { subject.should == Task.last }
      it('should return new task, modified_by person')      { subject.modified_by.should == @bob }
      it('should associate task with person as creator')    { subject.creator.should == @bob }
      it('should associate task with person as supervisor') { subject.supervisors.should == [@bob] }
    end

    describe '.create!' do
      before  { @bob = Person.named('bob') }

      it('should return task if new task created')        { @bob.tasks.create!(:title=>'foo').should be_kind_of(Task) }
      it('should raise error unless task created')        { lambda { @bob.tasks.create! }.should raise_error }
    end

    describe '.find' do
      before  do
        @bob = Person.named('bob')
        2.times do
          @bob.tasks.create! :title=>'foo'
        end
        Person.named('alice').tasks.create :title=>'bar'
      end

      it('should return the task, modified_by person')      { @bob.tasks.find(Task.first).modified_by.should == @bob }
      it('should return tasks, modified_by person')         { @bob.tasks.find(:all).map(&:modified_by).uniq.should == [@bob] }
      it('should not return tasks inaccessible to person')  { @bob.tasks.find(:all).size.should == 2 }
    end

  end

end
