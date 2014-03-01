class Api::Walla
  def tweet!(args)
    begin
      response = api.post "#{ENV['WALLA_URL']}/tweets.json", tweet: args
    rescue
      Rails.logger.error $!
      Rails.logger.error $!.backtrace.join("\n")
      return nil
    end

    if response.status == 201
      data  = JSON.parse(response.body)['tweet']
      url   = "#{ENV['WALLA_URL']}/go/#{data['id']}"

      return url
    end
    nil
  end

  protected
  def api
    @api ||= Faraday.new(:url => ENV['WALLA_URL']) do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter Faraday.default_adapter   # make requests with Net::HTTP
    end
  end
end
