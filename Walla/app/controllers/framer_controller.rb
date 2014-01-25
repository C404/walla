class FramerController < ApplicationController
  before_action :ip_env

  def index
    geoip = GeoIP.new("#{Rails.root}/config/GeoLiteCity.dat")
    geoip.city(@remote_ip)
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.customer_ip = @remote_ip
    @tweet.save

    # Fetch other urls suggestions
    @other_urls = AxaDocument.query(@tweet.message)
    if @other_urls.any?
      @other_urls = @other_urls[1,9].map { |i| {url: i.url, title: i.title} }
    end
    puts @other_urls.inspect
  end


  private

  def ip_env
    @remote_ip = '64.116.161.39' if Rails.env.development?
    @remote_ip ||= request.remote_ip
  end

end
