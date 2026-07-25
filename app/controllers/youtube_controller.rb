class YoutubeController < ApplicationController
  def show_channel
    service = YoutubeService.new
    channel_id = UC_lUyHT9gyGffD15oNaFRgw
    @channel = service.channel(channel_id)


  end
end