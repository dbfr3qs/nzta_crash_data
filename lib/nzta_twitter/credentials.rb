require 'json'

module NztaTwitter
  class Credentials
    attr_accessor :consumer_key
    attr_accessor :consumer_secret
    attr_accessor :access_token
    attr_accessor :access_token_secret

    def initialize()
      @auth = File.new("auth.json", "r")
      creds = JSON.parse(IO.read(@auth))
  		@consumer_key = creds["ConsumerKey"]
      @consumer_secret = creds["ConsumerSecret"]
  		@access_token = creds["AccessToken"]
      @access_token_secret = creds["AccessTokenSecret"]
    end

  end
end
