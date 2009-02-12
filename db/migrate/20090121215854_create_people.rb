# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with this
# work for additional information regarding copyright ownership.  The ASF
# licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.


class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string   :identity,                 :null => false
      t.string   :fullname,                 :null => false
      t.string   :email,                    :null => false
      t.string   :locale,     :limit => 5
      t.integer  :timezone,   :limit => 4
      t.string   :password,   :limit => 64
      t.string   :access_key, :limit => 32, :null => false
      t.timestamps
    end

    add_index :people, [:identity],   :unique => true
    add_index :people, [:access_key], :unique => true
    add_index :people, [:email],      :unique => true
    add_index :people, [:fullname]
  end

  def self.down
    drop_table :people
  end
end
