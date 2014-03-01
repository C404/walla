class CreateAutoResponders < ActiveRecord::Migration
  def change
    create_table :auto_responders do |t|
      t.string :matcher
      t.string :message

      t.timestamps
    end
  end
end
