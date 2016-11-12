require 'spec_helper'
require 'nzta_twitter/tweet'
require 'time'

describe NztaTwitter::Tweet do

  it 'can create a new tweet object and save it to the datastore' do
    tweet = NztaTwitter::Tweet.new()
    tweet.tweet_id = '12345567'
    tweet.body = 'tweet body'
    tweet.classifier = 1
    tweet.classified = 'false'
    tweet.date = Time.now.to_s
    tweet.save
  end

  it 'can retrieve the previously added record' do
    tweet = NztaTwitter::Tweet.where(TWEET_ID: '12345567').first
    expect(tweet.tweet_id).to eq '12345567'
  end

  it 'can update an existing tweet object' do
    tweet = NztaTwitter::Tweet.where(TWEET_ID: '12345567').first
    tweet.classified = 'true'
    tweet.save
    tweet = NztaTwitter::Tweet.where(TWEET_ID: '12345567').first
    expect(tweet.classified).to eq 'true'
  end

  it 'can remove the previously added record' do
    tweet = NztaTwitter::Tweet.where(TWEET_ID: '12345567').first
    tweet.destroy
  end
end
