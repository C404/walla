class AddsSuccessToTweet < ActiveRecord::Migration
  def change
    add_column :success, :tweets, :boolean, default: false
  end
end
