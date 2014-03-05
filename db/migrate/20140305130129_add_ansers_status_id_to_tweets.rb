class AddAnsersStatusIdToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :answer_status_id, :integer
    add_index  :tweets, :answer_status_id
  end
end
