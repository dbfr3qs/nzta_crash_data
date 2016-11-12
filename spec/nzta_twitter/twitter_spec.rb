require 'spec_helper'
require 'nzta_twitter/twitter'
require 'nzta_twitter/last_id'
require 'time'
require 'active_record'

describe NztaTwitter do

  # setup
  before(:all) do
    @client = NztaTwitter.get_client()
    @tweets = NztaTwitter.get_tweets(@client)
    @tweets_complete = NztaTwitter.get_all_tweets(@client)
    @tweets_written = []

    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => 'tweets_test.db',
      :host => 'localhost'
    )
    setup_test_tables()
  end

  # clean up
  after(:all) do
    destroy_test_tables()
    File.delete('tweets_test.db')
  end

  it 'can retrieve tweets from the nztawgtn twitter feed' do
    expect(@tweets).not_to be_empty
  end

  it 'can get the complete set of 3200 tweets' do
    expect(@tweets_complete.size).to eq 3200
  end

  it 'can save tweets to the database' do
    @tweets_written = NztaTwitter.save_tweets(@tweets)
    expect(@tweets_written.size).to eq @tweets.size
  end

  it 'can get the latest tweet id' do
    latest_tweet_id = NztaTwitter.get_latest_tweet_id(@client)
    expect(latest_tweet_id).to eq @tweets[0].id
  end

  it 'can get the last id stored in the last_ids database' do
    last_id = NztaTwitter::LastId.last.tweet_id
    latest_tweet_id = NztaTwitter.get_latest_tweet_id(@client)
    expect(last_id).to eq latest_tweet_id.to_s
  end

  it 'can get the latest tweets' do
    latest_tweet_id = NztaTwitter.get_latest_tweet_id(@client)
    last_id = @tweets_complete[451].id
    latest_tweets = NztaTwitter.get_latest_tweets(@client, last_id)
    latest = latest_tweets[0].id
    expect(latest).to eq latest_tweet_id
  end

  it 'can get new tweets' do
    tweets = NztaTwitter.get_tweets(@client, @tweets[3].id)
    expect(tweets.size).to eq 3
  end

  it 'can set a time object 12 hours ahead' do
    current_time = Time.now
    altered_time = NztaTwitter.change_time(current_time)
    expect(altered_time).to eq current_time+(60*60*12)
  end

end
