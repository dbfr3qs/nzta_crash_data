require 'nzta_twitter/tweet'
require 'colorize'

module NztaTwitter
  module Classify
    def self.class_tweet(tweet, classed_as)
      case classed_as
      when "1"
        tweet.classified = 'true'
        tweet.classifier = 1
        tweet.save
        puts "classed as positive (1)"
      when "0"
        tweet.classified = 'true'
        tweet.classifier = '0'
        puts "classed as negative (0)"
        tweet.save
      when ""
        tweet.classified = 'true'
        tweet.classifier = '0'
        puts "classed as negative (0)"
        tweet.save
      end
    end

    def self.classify()
      NztaTwitter::Tweet.where(classified: 'false').find_each do |tweet|
        print "Tweet #{tweet.tweet_id} text:\n"
        print "#{tweet.body}\n".colorize(:green)
        print "Classify (1=postive, 0 or blank = negative):"
        classed_as = STDIN.gets.strip!
        class_tweet(tweet, classed_as)
      end
    end

  end
end
