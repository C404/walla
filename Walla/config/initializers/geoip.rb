GEOIP_DB = Rails.root.join('config', 'GeoLiteCity.dat')

if File.readable?(GEOIP_DB)
  GEOIP = GeoIP.new(GEOIP_DB)
else
  msg = <<-EOS
    It appears you don't have Maxmind's GeoIP database installed.
    Please go to http://dev.maxmind.com/geoip/legacy/geolite/, download
    the city database and place it here: #{GEOIP_DB}
  EOS
  puts msg
  Rails.logger.error msg
end
