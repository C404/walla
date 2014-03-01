class Bot::Twitter
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def on_event(event)
    # "Twitter::Streaming::StallWarning" => stall_warning
    name = event.class.name.demodulize.underscore

    if respond_to? "on_#{name}"
      __send__("on_#{name}", event)
    else
      on_other(event)
    end
  end

  def on_stall_warning(event)
    Rails.logger.warn "Twitter::Bot is falling behind"
  end

  def on_other(event)
    Rails.logger.error "We got an unhandled event #{event.class} : #{event.inspect}"
  end
end
