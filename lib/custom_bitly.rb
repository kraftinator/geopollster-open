require 'rubygems'
require 'httparty'
class CustomBitly
  include HTTParty
  base_uri "api.bit.ly"

  @@login   = "geopollster"
  @@api_key = ENV['BITLY_API_KEY']

  def self.shorten(url)
    response = get("/v3/shorten?login=#{@@login}&apiKey=#{@@api_key}&longUrl=#{url}")
    response["data"]["url"]
  end
end