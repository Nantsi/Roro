require "httparty"

class YoutubeService
  BASE_URL = "https://www.googleapis.com/youtube/v3"

  def initialize
    @api_key = Rails.application.credentials.youtube[:api_key]
  end

  def channel(id)
    response = HTTParty.get(
      "#{BASE_URL}/channels",
      query: {
        key: @api_key,
        id: id,
        part: "snippet,statistics,contentDetails"
      }
    )

    JSON.parse(response.body)
  end

  def latest_upload(playlist_id)
  response = HTTParty.get(
    "#{BASE_URL}/playlistItems",
    query: {
      key: @api_key,
      playlistId: playlist_id,
      part: "snippet",
      maxResults: 1
    }
  )

  JSON.parse(response.body)
end

def current_livestream(channel_id)
  response = HTTParty.get(
    "#{BASE_URL}/search",
    query: {
      key: @api_key,
      channelId: channel_id,
      eventType: "live",
      type: "video",
      part: "snippet",
      maxResults: 1
    }
  )

  JSON.parse(response.body)
end
 
end