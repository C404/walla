class TwitterProfile
  attr_reader :account

  def initialize(account)
    @tw = TwitterFactory.create_client
    @account = account
  end

  def timeline
    @timeline ||= @tw.user_timeline(account, count: 200, include_entities: true)
  end

  # Return every hashtag that has been used at least twice in the last
  # 200 tweets
  def favorite_hashtags
    favorite_stuffs(:hashtags, :text, 3)
  end

  def favorite_users
    favorite_stuffs(:user_mentions, :screen_name, 3)
  end

  def favorite_stuffs(entity_name, entity_key, threshold)
    counter = timeline.map { |t| t.send(entity_name) }
      .inject(Hash.new) do |counter, entities|
        entities.each do |entity|
          key = entity.send(entity_key)

          counter[key] ||= 0
          counter[key] = counter[key] + 1
        end

      counter
    end

    counter.delete_if { |entity, count| count < threshold }
  end
end
