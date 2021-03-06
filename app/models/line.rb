class Line
  def self.echo to, text
    request_content = { 
      to: [to],
      toChannel: 1383378250, # Fixed  value
      eventType: "138311608800106203", # Fixed value
      content: {"toType"=>1, "text"=>text, "contentType"=>1}
    }   

    http_client = HTTPClient.new
    endpoint_uri = 'https://trialbot-api.line.me/v1/events'
    content_json = request_content.to_json
    http_client.post_content(endpoint_uri, content_json,
        'Content-Type' => 'application/json; charset=UTF-8',
        'X-Line-ChannelID' => ENV["LINE_CHANNEL_ID"],
        'X-Line-ChannelSecret' => ENV["LINE_CHANNEL_SECRET"],
        'X-Line-Trusted-User-With-ACL' => ENV["LINE_CHANNEL_MID"]
     )   
  end 
end

