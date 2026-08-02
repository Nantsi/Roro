class PagesController < ApplicationController
  def home

    service = YoutubeService.new
    
    channel_id = "UC55-Y4cBl6alNaaOVVEYgSA"
    @channel = service.channel(channel_id)
    channel = @channel["items"].first
    
    @current_video = service.latest_upload(channel["contentDetails"]["relatedPlaylists"]["uploads"])["items"].first
    @upcoming_streams = []
    @upcoming_times = []
    



    service.latest_upload(channel["contentDetails"]["relatedPlaylists"]["uploads"])["items"].each do |item|
      video_id = item["snippet"]["resourceId"]["videoId"]

     

      video = service.video_details(video_id)

      details = video["items"].first["liveStreamingDetails"]

     

      # Skip scheduled livestreams
      if details && details["scheduledStartTime"] && details["actualStartTime"].nil?
        @upcoming_streams << item
        @upcoming_times << details["scheduledStartTime"]
        next
        end
      
        
        @latest_video_time ||= if details && details["actualEndTime"]
                          details["actualEndTime"]
                        if details && details["scheduledStartTime"] && details["actualStartTime"] && details["actualEndTime"].nil?
                          details["actualStartTime"]
                        else
                          details["actualEndTime"]
                        end
                      end


        @latest_video ||= if details && details["actualEndTime"]
                          item
                        if details && details["scheduledStartTime"] && details["actualStartTime"]
                          item
                        else
                          item
                        end
                      end
       


      if details && details["scheduledStartTime"] && details["actualStartTime"]
        @current_stream = item
        @current_stream_time = details["actualStartTime"]
      end
        
    end
    

    if @livestream = service.current_livestream(channel_id)["items"]
      @livestream = service.current_livestream(channel_id)["items"].first
    end
    if @livestream
      video_id = @livestream["id"]["videoId"]
      video_url = "https://www.youtube.com/watch?v=#{video_id}"
      puts "Current livestream URL: #{video_url}"
    end

  end
end
