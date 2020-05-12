require './lib/client.rb'
require 'dotenv/load'
require 'twitter'
require 'yaml'

module User
  def self.store_tweet(tweets = [])
    tweets += Client::C.user_timeline('qualitycodebot', count: 1)
    File.write('tweets.yml', YAML.dump(tweets))
  end

  def self.like_retweets(tweets, fav_tweets = [])
    tweets = Client::C.statuses(tweets)
    no_unliked = true
    tweets.each do |tweet|
      unliked_tweets = Client::C.retweets(tweet) - fav_tweets
      no_unliked = false unless unliked_tweets.empty?
      fav_tweets += Client::C.fav(unliked_tweets) unless unliked_tweets.empty?
    end
    File.write('fav_tweets.yml', YAML.dump(fav_tweets)) unless no_unliked
  end

  def self.retweets_received(tweets)
    tweets = Client::C.statuses(tweets)
    tweets.reduce(0) { |sum, tweet| sum + tweet.retweet_count }
  end

  def self.likes_received(tweets)
    tweets = Client::C.statuses(tweets)
    tweets.reduce(0) { |sum, tweet| sum + tweet.favorite_count }
  end
end
