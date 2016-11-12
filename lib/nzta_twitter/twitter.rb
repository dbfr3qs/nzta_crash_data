require 'twitter'
require 'nzta_twitter/tweet'
require 'nzta_twitter/last_id'

module NztaTwitter
  def self.get_client()
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = "mYbAx5Hs7AkfYJldC1hWU8R07"
      config.consumer_secret     = "8Sn3Oy2xiVjRbRG6c3bOyyC41mJM7chkjLG9tSRFlphIYvARKE"
      config.access_token        = "3323005244-Jx43rgPqWnf1hq6nptm1XxvLM2AfsapvSBkc2eR"
      config.access_token_secret = "ENV36a9gYVaC9wXCH3Xv7uqKOuf5r5CkT4NUagGveWtRh"
    end
    client
  end

  # get the most recent tweets
  def self.get_tweets(client, last_id=nil)
    options = (last_id == nil ? { :count => 200 } : { :count => 200, :since_id => last_id })
    client.user_timeline('nztawgtn', options)
  end

  def self.get_latest_tweet_id(client)
    options = { :count => 1 }
    latest_tweet_id = client.user_timeline('nztawgtn', options)[0].id
    latest_tweet_id
  end

  def self.get_latest_tweets(client, last_id)
    #tweets = []
    latest_tweet_id = get_latest_tweet_id(client)
    new_tweets = get_tweets(client, last_id)
    tweets = new_tweets
    until new_tweets.first.id == latest_tweet_id do
      last_id = new_tweets.first.id
      new_tweets = get_tweets(client, last_id)
      tweets = new_tweets + tweets
    end
    tweets
  end

  # get all of the available 3200 tweets
  def self.get_all_tweets(client)
    options = { :count => 200 }
    tweets = client.user_timeline('nztawgtn', options)
    max_id = tweets.last.id

    until tweets.size == 3200 do
      options = { :count => 200, :max_id => max_id }
      tweets += client.user_timeline('nztawgtn', options)
      max_id = tweets.last.id
    end
    tweets
  end

  def self.change_time(time)
    time+(60*60*12)
  end

  def self.save_tweets(tweets)
    tweets_collection = []
    tweets.each do |tweet|
      twt = Tweet.new()
      twt.tweet_id = tweet.id
      twt.body = tweet.text
      twt.date = change_time(tweet.created_at)
      twt.classifier = 0
      twt.classified = 'false'
      tweets_collection << twt
      twt.save
    end
    last_id = LastId.new()
    last_id.tweet_id = tweets.first.id
    last_id.date = change_time(tweets.last.created_at)
    last_id.save
    tweets_collection
  end
end
