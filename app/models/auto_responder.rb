class AutoResponder < ActiveRecord::Base
  validate :regexp_is_valid?

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
        if Regexp.new(responder.matcher).match message
          puts "Matching: #{responder.matcher}"
          return responder.message
        else
          puts "NOT Matching: #{responder.matcher}"
        end
      end

      return false
    end
  end
end
