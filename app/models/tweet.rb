class Tweet < ActiveRecord::Base

  def message_url
    "http://twitter.com/#{account}/status/#{status_id}"
  end

  def go_url
    "#{ENV['WALLA_URL']}/go/#{self.id}"
  end

  def set_user_ip remote_ip
    self.customer_ip = remote_ip
    self.save!
  end

  def full_name
    client = TwitterFactory.create_client

    begin
      client.user(self.account).name.underscore.gsub('_', ' ')
    rescue
      nil
    end
  end
end
