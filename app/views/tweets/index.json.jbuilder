json.array!(@tweets) do |tweet|
  json.extract! tweet, :id, :customer_account, :customer_msg, :msg_url, :service_page, :agent_account, :bitly, :chatter_id, :customer_ip, :answered_url
  json.url tweet_url(tweet, format: :json)
end
