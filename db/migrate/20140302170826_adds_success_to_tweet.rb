class AddsSuccessToTweet < ActiveRecord::Migration
  def change
    add_column :tweets, :success, :boolean, default: false
  end
end
