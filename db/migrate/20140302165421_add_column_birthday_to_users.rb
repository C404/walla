class AddColumnBirthdayToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :datetime
  end
end
