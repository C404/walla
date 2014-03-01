class CreateAutoResponders < ActiveRecord::Migration
  def change
    create_table :auto_responders do |t|
      t.string  :matcher
      t.string  :message
      t.boolean :enabled

      t.timestamps
    end

    add_index :auto_responders, :enabled
  end
end
