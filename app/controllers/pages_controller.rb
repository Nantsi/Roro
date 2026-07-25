class PagesController < ApplicationController
  def home
    service = YoutubeService.new
    channel_id = "UC_lUyHT9gyGffD15oNaFRgw"
    @channel = service.channel(channel_id)
    channel = @channel["items"].first
    @latest_video = service.latest_upload(channel["contentDetails"]["relatedPlaylists"]["uploads"])["items"].first
  end
end
