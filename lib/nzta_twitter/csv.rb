require 'nzta_twitter/tweet'
require 'csv'
require 'colorize'

module NztaTwitter
  module Csv
    class TweetCsv
      attr_accessor :features_list
      attr_accessor :label
    end

    @@feature_list = Hash.new
    @@tweets = []

    def self.process_tweet_body_for_index(body)
      words = body.split(' ')
      words.each do |word|
        unless @@feature_list.has_key? word.to_sym
          @@feature_list[word] = 0
        end
      end
    end

    def self.build_feature_index()
      tweets = NztaTwitter::Tweet.where(classified: 'true').find_each
      tweets.each do |tweet|
        process_tweet_body_for_index(tweet.body)
      end
      puts "The features list contains #{@@feature_list.size} elements".colorize(:green)
    end

    def self.process_tweet_for_features(tweet)
      twt = TweetCsv.new
      twt.features_list = @@feature_list.dup
      words = tweet.body.split(' ')
      words.each do |word|
        twt.features_list[word] += 1
      end
      twt.label = tweet.classifier
      @@tweets << twt
    end

    def self.process_tweets_into_features()
      tweets = NztaTwitter::Tweet.where(classified: 'true').find_each
      tweets.each do |tweet|
        process_tweet_for_features(tweet)
      end
    end

    def self.get_feature_list()
      @@feature_list
    end

    def self.get_csv()
      @@tweets
    end

    def self.write_features_csv()
      # splits train and test sets 70/30
      idx_train = (0.7 * @@tweets.size).to_i
      tweets_train = @@tweets.slice(0,idx_train)
      tweets_test = @@tweets.slice(idx_train, @@tweets.size-1)
      CSV.open("data/features_train.csv", "wb") do |csv|
        tweets_train.each do |tweet|
          csv << tweet.features_list.values
        end
      end
      puts "Wrote #{tweets_train.size} sets to features_train.csv".colorize(:green)
      CSV.open("data/features_test.csv", "wb") do |csv|
        tweets_test.each do |tweet|
          csv << tweet.features_list.values
        end
      end
      puts "Wrote #{tweets_test.size} sets to features_test.csv".colorize(:green)
    end

    def self.write_labels_csv()
      # splits train and test sets 70/30
      idx_train = (0.7 * @@tweets.size).to_i
      tweets_train = @@tweets.slice(0,idx_train)
      tweets_test = @@tweets.slice(idx_train, @@tweets.size-1)
      CSV.open("data/labels_train.csv", "wb") do |csv|
        tweets_train.each do |tweet|
          if tweet.label == "1"
            csv << ["1", "0"]
          else
            csv << ["0", "1"]
          end
        end
      end
      puts "Wrote #{tweets_train.size} sets to labels_train.csv".colorize(:green)
      CSV.open("data/labels_test.csv", "wb") do |csv|
        tweets_test.each do |tweet|
          if tweet.label == "1"
            csv << ["1", "0"]
          else
            csv << ["0", "1"]
          end
        end
      end
      puts "Wrote #{tweets_test.size} sets to labels_train.csv".colorize(:green)
      puts "Sourced from a total of #{tweets_test.size + tweets_train.size} tweets".colorize(:green)
    end

  end
end
