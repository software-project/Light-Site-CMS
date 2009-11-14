class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles" do |t|
      t.string :name
    end
    
    # generate the join table
    create_table "roles_users", :id => false do |t|
      t.integer "role_id", "user_id"
    end
    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"

    Role.create( :name => 'admin')
    user = User.create( :name => 'admin', :login => 'admin', :password => 'administrator', :password_confirmation => 'administrator', :email => 'admin@admin.pl', :activated_at => Date.today)
    user.roles << Role.find_by_name('admin')
    user.activate!
    user.save!
  end

  def self.down
    drop_table "roles"
    drop_table "roles_users"
  end
end