class Tweet < ActiveRecord::Base

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
