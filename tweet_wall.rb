require 'rubygems'
require 'ruby-processing'
require 'net/http'
require 'oauth'
require 'json'
require 'thread'

$mutex = Mutex.new

class TweetWall < Processing::App

  CONSUMER_KEY = 'xxxxxxxxx'
  CONSUMER_SECRET = 'xxxxxxxxx'
  OAUTH_TOKEN = 'xxxxxxxxx'
  OAUTH_SECRET = 'xxxxxxxxx'

  def setup
    @bg_x = -200
    @bg_y = 0
    start_text = "tweet #oreos to get on the tweet wall"
    @tweets = [[start_text, 800, 50]]

    @consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET)                                              
    @access = OAuth::Token.new(OAUTH_TOKEN, OAUTH_SECRET)                                                       

    uri = URI("https://stream.twitter.com/1.1/statuses/filter.json?track=oreos")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    Thread.new {
      http.start do |http|
        request = Net::HTTP::Post.new uri.request_uri
        request.oauth!(http, @consumer, @access)

        http.request request do |response|
          response.read_body do |chunk|
            j = JSON.parse(chunk)
            text = "#{j["user"]["screen_name"]}: #{j["text"]}" 
            puts text
            $mutex.synchronize do
              if @tweets.length > 25
                @tweets = []
              end
              @tweets << [text, width, rand(height - (32))]
            end
          end
        end
      end
    }
  end
  def draw
    background(255)
    text_size(32)
    fill(rand(255), rand(255),rand(255))

    $mutex.synchronize do
      @tweets = @tweets.map do |tweet, x, y|
        text(tweet, x, y)
        if x <= (0-text_width(tweet))
          tweet, x, y = tweet, width, rand(height-32)
        else
          tweet, x, y = tweet, x - 10, y
        end
      end
    end

  end
end

TweetWall.new :title => "TweetWall", :width => 1024, :height => 600, :fullscreen => false
