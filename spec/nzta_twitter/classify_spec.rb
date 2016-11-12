require 'spec_helper'
require 'nzta_twitter/classify'
require 'nzta_twitter/tweet'

describe NztaTwitter::Classify, :classify => true do
  # setup
  before(:all) do
      @tweet = NztaTwitter::Tweet.new()
      @tweet.tweet_id = '12345567'
      @tweet.body = 'tweet body'
      @tweet.classifier = 1
      @tweet.classified = 'false'
      @tweet.date = Time.now.to_s
      @tweet.save
  end

  after(:all) do
    @tweet.destroy
  end

  it 'can classify an unclassified tweet' do
    NztaTwitter::Classify.class_tweet(@tweet, "1")
    @tweet = NztaTwitter::Tweet.find_by(tweet_id: '12345567')
    expect(@tweet.classified).to eq "true"
    expect(@tweet.classifier).to eq "1"
  end
end
