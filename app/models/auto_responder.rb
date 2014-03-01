class AutoResponder < ActiveRecord::Base
  validate :regexp_is_valid?
  validate :message, length: {minimum: 5, maximum: (140 - 20)}

  scope :enabled, ->{where(enabled: true)}

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
    def respond(message)
      AutoResponder.enabled.each do |responder|
        return responder.message if Regexp.new(responder.matcher).match message
      end

      return false
    end
  end
end
