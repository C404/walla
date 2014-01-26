class FramerController < ApplicationController
  before_action :ip_env

  def index
    @city = GEOIP.city(@remote_ip)
    @city = @city[:city_name] || @city[:country_name]

    @tweet = Tweet.find_by_id(params[:id])
    @tweet.set_user_ip @remote_ip if @tweet

    # Fetch other urls suggestions
    @other_urls = AxaDocument.query(@tweet.message)
    if @other_urls.any?
      @other_urls = @other_urls[1,9].map { |i| {url: i.url, title: i.title} }
    end
    puts @other_urls.inspect
  end

  def next
    begin
      @tweet = Tweet.find(params[:id])
      NextWorker.perform_async(@tweet.id)
      render nothing: true
    rescue
      Rails.logger.error "Rescued from #{$!} (#{$!.class})"
      Rails.logger.error "-- Backtrace:\n#{$!.backtrace.join("\n")}"
      render nothing: true, status: :unprocessable_entity
    end
  end

  private
  def ip_env
    @remote_ip = '78.249.102.240' if Rails.env.development?
    @remote_ip ||= request.remote_ip
  end
end
