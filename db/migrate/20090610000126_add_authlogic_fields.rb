class AddAuthlogicFields < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      # Authlogic uses these:
      t.string  :login,               :null => false
      t.string  :crypted_password,    :null => false
      t.string  :password_salt,       :null => false
      t.string  :persistence_token,   :null => false
      t.string  :single_access_token, :null => false
      t.string  :perishable_token,    :null => false
      # So we no longer need this.
      t.remove  :identity
      t.remove  :password
      t.remove  :access_key
    end 
  end

  def self.down
    change_table :people do |t|
      t.remove  :login
      t.remove  :crypted_password
      t.remove  :password_salt
      t.remove  :persistence_token
      t.remove  :single_access_token
      t.remove  :perishable_token
      t.string  :identity,                 :null => false
      t.string  :password,   :limit => 64
      t.string  :access_key, :limit => 32, :null => false
    end
  end
end
