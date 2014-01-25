class Tweet < ActiveRecord::Base

  def set_user_ip remote_ip
    self.customer_ip = remote_ip
    self.save!
  end

end
