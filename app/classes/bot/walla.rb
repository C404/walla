class Bot::Walla < Bot::Twitter
  def on_tweet(event)
    me = client.user(skip_status: true)

    if event.user.screen_name != me.screen_name and event.in_reply_to_status_id.nil?
      response = Api::Walla.new.tweet!( account: event.user.screen_name,
                                        message: event.text,
                                        message_url:  event.url )

      if response
        client.update("@#{event.user.screen_name}, Je vous suggère cette page: #{response}",
          in_reply_to_status: event)
      else
        client.update("Désolé @#{event.user.screen_name}, je ne sais pas comment vous aider :-/",
          in_reply_to_status: event)
      end
    end
  end

  def on_direct_message(event)
    puts "This dumbass is talking to me :-/ Make it stop!"
    puts event.inspect
  end
end
