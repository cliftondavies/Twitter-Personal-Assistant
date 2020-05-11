require 'dotenv/load'
require 'twitter'
require 'yaml'

module User
  CLIENT = Twitter::REST::Client.new(Client.config)

  def self.store_tweet(tweets = [])
    tweets += client.user_timeline('qualitycodebot', count: 1)
    File.write('tweets.yml', YAML.dump(tweets))
  end

  def self.like_retweets(tweets, fav_tweets = [])
    tweets.each do |tweet|
      unliked_tweets = client.retweets(tweet) - fav_tweets
      fav_tweets += client.fav(unliked_tweets) unless unliked_tweets.size.zero?
    end
    File.write('fav_tweets.yml', YAML.dump(fav_tweets)) unless fav_tweets.empty?
  end

  def self.retweets_received(tweets)
    tweets.reduce(0) { |sum, tweet| sum + tweet.retweet_count }
  end

  def self.likes_received(tweets)
    tweets.reduce(0) { |sum, tweet| sum + tweet.favorite_count }
  end
end
