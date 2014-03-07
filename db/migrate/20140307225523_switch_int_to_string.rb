class SwitchIntToString < ActiveRecord::Migration
  def change
    change_column :tweets, :status_id, :string
  end
end
