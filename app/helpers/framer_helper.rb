module FramerHelper

  def extract_profile user_name='find_lta'
    return TwitterProfile.new(user_name)
  end

end
