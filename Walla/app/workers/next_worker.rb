class NextWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    begin
      @tweet = Tweet.find(tweet_id)

      Rails.logger.info "Launching NextWorker for tweet #{tweet_id}"
      # Recherche du client dans SF (@tweet.full_name)
      sf_existing_account = false

      if @tweet.full_name
        query = @tweet.full_name.gsub ' ', '*'
        sf_account = Account.search("Find {#{query}} RETURNING Account").first
        if sf_account
          sf_owner_id = sf_account.OwnerId
          sf_existing_account = true
        end
      end

      # Recherche d'un User randomement geolocalise
      sf_owner_id ||= User.find_by_name('Grouillot').Id

      # Recherche dans la KB SF d'articles en rapport avec le tweet
      # page = SF_CLIENT.search("FIND {SENS aime text} RETURNING ClientProcess__kav(Id WHERE PublishStatus='Online' AND Language='fr')").first

      # Creation d'une task
      if sf_existing_account
        attributes = {
          "Subject" => "#{sf_account.Name} a posé une question sur Twitter",
          "WhatId" => sf_account.Id,
          "Description" => <<-DESC

          Un de vos clients a posé une question à notre robot de support via
          Twitter, mais la réponse du robot ne l'a pas satisfait(e). Vous
          pouvez répondre à sa question sur Twitter à cette addresse :
          #{@tweet.message_url}

          DESC
        }
      else
        attributes = {
          "Subject" => "Un utilisateur de Twitter proche de votre agence a posé une question sur Twitter",
          "Description" => <<-DESC

          Un utilisateur de Twitter a posé une question à notre robot de
          support, mais la réponse du robot ne l'a pas satisfait(e).
          Lors de sa visite sur notre site, nous avons detecté que cet utilisateur
          est situé dans une zone proche de votre agence. Nous vous invitons à
          répondre à sa demande ou à sa remarque directement sur Twitter,
          à cette addresse: #{@tweet.message_url}

          DESC
        }
      end

      #debugger

      Sf::Task.create(attributes.merge('OwnerId' => sf_owner_id))
    rescue
      Rails.logger.error "Rescued from #{$!} (#{$!.class})"
      Rails.logger.error "-- Backtrace:\n#{$!.backtrace.join("\n")}"
    end
  end
end
