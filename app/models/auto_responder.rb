class AutoResponder < ActiveRecord::Base
  validate :regexp_is_valid?

  private
  def regexp_is_valid?
    begin
      Regexp.new(self.matcher)
      true
    rescue
      errors.add :matcher, $!.to_s
      false
    end
  end


  class << self
    def respond(tweet)
    end
  end
end
