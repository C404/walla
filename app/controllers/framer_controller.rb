class FramerController < ApplicationController
  before_action :ip_env
  before_action :set_tweet, except: [:stats, :profiles]

  def index
    begin
      if @remote_ip =~ /62\.210\./
        @city = 'Paris (75017)'
      else
        @city = GEOIP.city(@remote_ip)
        @city = @city[:city_name] || @city[:country_name]
      end
    rescue
      @city = "???"
    end

    @tweet = Tweet.find_by_id(params[:id])
    @tweet.set_user_ip @remote_ip if @tweet

    # Fetch other urls suggestions
    @other_urls = AxaDocument.query(@tweet.message)
    if @other_urls.any?
      @other_urls = @other_urls[1,9].map { |i| {url: i['url'], title: i['title']} }
    end
    Rails.logger.warn "Query result : #{@other_urls.inspect}"
  end

  def next
    begin
      @tweet.update_attribute(:success, false)
      NextWorker.perform_async(@tweet.id)
      render nothing: true
    rescue
      Rails.logger.error "Rescued from #{$!} (#{$!.class})"
      Rails.logger.error "-- Backtrace:\n#{$!.backtrace.join("\n")}"
      render nothing: true, status: :unprocessable_entity
    end
  end

  def learn
    puts "Should learn url #{params[:url]}"

    @tweet.update_attribute(:success, true)
  end


  def stats
    if !user_signed_in? and Rails.env != 'development'
      redirect_to new_user_session_url(state: request.original_url)
    else
      @week = ['none', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim']
    end
  end

  def profiles
    if !user_signed_in? and Rails.env != 'development'
      redirect_to new_user_session_url(state: request.original_url)
    else
      @users = Tweet.select("DISTINCT account")
    end
  end

  private
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def ip_env
    @remote_ip = '78.249.102.240' if Rails.env.development?
    @remote_ip ||= request.remote_ip
  end
end
