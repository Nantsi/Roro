class PagesController < ApplicationController
  def home

    service = YoutubeService.new
    
    channel_id = "UC_lUyHT9gyGffD15oNaFRgw"
    @channel = service.channel(channel_id)
    channel = @channel["items"].first
    
    @latest_video = service.latest_upload(channel["contentDetails"]["relatedPlaylists"]["uploads"])["items"].first
    
    if @livestream = service.current_livestream(channel_id)["items"]
      @livestream = service.current_livestream(channel_id)["items"].first
    end
    if @livestream
      video_id = @livestream["id"]["videoId"]
      video_url = "https://www.youtube.com/watch?v=#{video_id}"
    end

  end
end
