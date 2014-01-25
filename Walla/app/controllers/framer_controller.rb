class FramerController < ApplicationController
  before_action :ip_env

  def index
    geoip = GeoIP.new("#{Rails.root}/config/GeoLiteCity.dat")
    geoip.city(@remote_ip)
  end


  private

  def ip_env
    @remote_ip = '64.116.161.39' if Rails.env.development?
    @remote_ip ||= request.remote_ip
  end

end
