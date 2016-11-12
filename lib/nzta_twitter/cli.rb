require 'thor'
require 'nzta_twitter/twitter'
require 'nzta_twitter/classify'
require 'colorize'

module NztaTwitter
  class Cli < Thor

    desc "get_all", "gets all 3200 available tweets. Use this when running for the first time"
    def get_all_tweets()
      puts "Getting all 3200 available tweets...".colorize(:green)
      tweets = NztaTwitter.get_all_tweets()
      NztaTwitter.save_tweets(tweets)
      puts "Done.".colorize(:green)
    end

    desc "get_latest", "get the latest tweets since the last scrape"
    def get_latest()
      puts "getting the latest available tweets...".colorize(:green)
      tweets = NztaTwitter.get_latest_tweets()
      NztaTwitter.save_tweets(tweets)
      puts "Done.".colorize(:green)
    end

    desc "get_tweets", "gets the last 200 tweets"
    def get_tweets()
      puts "Getting the last 200 tweets...".colorize(:green)
      tweets = NztaTwitter.get_tweets()
      NztaTwitter.save_tweets(tweets)
      puts "Done.".colorize(:green)
    end

    desc "classify", "classify non classified records in the database"
    def classify()
      NztaTwitter::Classify.classify()
    end
  end
end
