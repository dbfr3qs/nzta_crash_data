require 'spec_helper'
require 'nzta_twitter/tweet'
require 'nzta_twitter/csv'
require 'nzta_twitter/twitter'

describe NztaTwitter::Csv, :csv => true do
  before(:all) do
    @tweets = NztaTwitter.get_tweets()
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => 'tweets_test.db',
      :host => 'localhost'
    )
    setup_test_tables()
    NztaTwitter.save_tweets(@tweets)
    @tweet = NztaTwitter::Tweet.find(1)
    @new_tweet = NztaTwitter::Tweet.find(100)
  end

  after(:all) do
    destroy_test_tables()
  end

  it 'can create a feature list from a tweet body' do
    NztaTwitter::Csv.process_tweet_body_for_index(@tweet.body)
    feature_list_size = NztaTwitter::Csv.get_feature_list().size
    compare_list_size = @tweet.body.split(' ').size
    expect(feature_list_size).to_not eq 0
    expect(feature_list_size).to eq compare_list_size
  end

  it 'will not add any more words to the feature list if they already exist' do
    NztaTwitter::Csv.process_tweet_body_for_index(@tweet.body)
    feature_list_size = NztaTwitter::Csv.get_feature_list().size
    NztaTwitter::Csv.process_tweet_body_for_index(@tweet.body)
    expect(feature_list_size).to eq NztaTwitter::Csv.get_feature_list().size
  end

  it 'will add new words to the feature list if they do not exist' do
    NztaTwitter::Csv.process_tweet_body_for_index(@tweet.body)
    feature_list_size = NztaTwitter::Csv.get_feature_list().size
    NztaTwitter::Csv.process_tweet_body_for_index(@new_tweet.body)
    expect(@tweet.body).to_not eq @new_tweet.body
    expect(feature_list_size).to be < NztaTwitter::Csv.get_feature_list().size
  end

  it 'will update the features list with new words' do
    NztaTwitter::Csv.process_tweet_for_features(@tweet)
    csv = NztaTwitter::Csv.get_csv()
    words = @tweet.body.split(' ')
    expect(csv[0].features_list[words[0]]).to eq 1
    expect(csv[0].features_list[words[words.size-1]]).to eq 1
    expect(csv[0].label).to eq @tweet.classifier
  end

end
