class FramerController < ApplicationController
  before_action :ip_env

  def index
    geoip = GeoIP.new("#{Rails.root}/config/GeoLiteCity.dat")
    @city = geoip.city(@remote_ip)
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.set_user_ip @remote_ip if @tweet
    # Fetch other urls suggestions
    @other_urls = AxaDocument.query(@tweet.message)
    if @other_urls.any?
      @other_urls = @other_urls[1,9].map { |i| {url: i.url, title: i.title} }
    end
    puts @other_urls.inspect
  end

  #testing next
  def next
    raise "HERE WE ARE ID => #{params[:id].inspect}"
  end



  private
  def ip_env
    @remote_ip = '78.249.102.240' if Rails.env.development?
    @remote_ip ||= request.remote_ip
  end
end
