class PagesController < ApplicationController
  def home

    service = YoutubeService.new
    
    channel_id = "UC_lUyHT9gyGffD15oNaFRgw"
    @channel = service.channel(channel_id)
    channel = @channel["items"].first
    
    @current_video = service.latest_upload(channel["contentDetails"]["relatedPlaylists"]["uploads"])["items"].first
    @latest_video = @current_video
    @upcoming_streams = []


    service.latest_upload(channel["contentDetails"]["relatedPlaylists"]["uploads"])["items"].each do |item|
      video_id = item["snippet"]["resourceId"]["videoId"]

     

      video = service.video_details(video_id)

     details = video["items"].first["liveStreamingDetails"]

     puts item
     

        # Skip scheduled livestreams
        if details && details["scheduledStartTime"] && details["actualStartTime"].nil?
          puts details["scheduledStartTime"]
          @upcoming_streams << item
          next
        end
        puts item["snippet"]["title"]
        @latest_video = item

        puts item
        
        break
    end
    
    if @livestream = service.current_livestream(channel_id)["items"]
      @livestream = service.current_livestream(channel_id)["items"].first
    end
    if @livestream
      video_id = @livestream["id"]["videoId"]
      video_url = "https://www.youtube.com/watch?v=#{video_id}"
    end

  end
end
