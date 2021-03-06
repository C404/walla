class Bot::Walla < Bot::Twitter
  def should_answer_to?(event)
    mentions = event.user_mentions.map{|u| u.screen_name}

    if event.user.screen_name == me.screen_name
      Rails.logger.warn "Bot::Walla, not answering to myself"
      return false
    end
    #Rails.logger.warn "This is reply to #{event.in_reply_to_status_id} #{event.in_reply_to_status_id.class}"
    if event.in_reply_to_status_id and Tweet.where(answer_status_id: event.in_reply_to_status_id).exists?
      Rails.logger.warn "Bot::Walla, don't reply to my own reply"
      return false
    end

    unless mentions.include? me.screen_name
      Rails.logger.warn "Bot::Walla, This message isn't a message to me"
      return false
    end

    Rails.logger.debug "Answering message: #{event.text}"

    true
  end

  def me
    @me ||= client.user(skip_status: true)
  end

  def on_tweet(event)
    if should_answer_to?(event)
      # If we find a matching AutoResponder for this tweet, we use it as answer
      # and exit the regular flow
      auto_response = AutoResponder.respond(event.text)

      if auto_response
        client.update("@#{event.user.screen_name}, #{auto_response}",
          in_reply_to_status: event)
        return
      end

      # We haven't found an AutoResponder, let's ask our API/ElasticSearch
      # if we can find smth to answer :)
      response = Api::Walla.new.tweet!( account: event.user.screen_name,
                                        message: event.text,
                                        status_id:  event.id )

      if response
        tweet = Tweet.find(response['id'])
        status = client.update("@#{event.user.screen_name}, Je vous suggère cette page: #{tweet.go_url}",
          in_reply_to_status: event)
        tweet.update_attribute(:answer_status_id, status.id)
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
