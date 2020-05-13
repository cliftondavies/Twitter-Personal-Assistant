require './lib/client.rb'
require 'dotenv/load'
require 'twitter'
require 'yaml'

module User
  def self.store_tweet(tweets = [])
    tweets += Client::C.user_timeline(Client::C.user.id, count: 1)
    File.write('tweets.yml', YAML.dump(tweets))
    tweets
  end

  def self.like_retweets(tweets, fav_tweets = [])
    tweets = Client::C.statuses(tweets)
    no_unliked = true
    tweets.each do |tweet|
      unliked_tweets = Client::C.retweets(tweet) - fav_tweets
      # no_unliked = false unless unliked_tweets.empty?
      # fav_tweets += Client::C.fav!(unliked_tweets) unless unliked_tweets.empty?
      unless unliked_tweets.empty?
        no_unliked = false
        Client::C.unfavorite(unliked_tweets)
        fav_tweets += Client::C.fav!(unliked_tweets)
      end
    end
    File.write('fav_tweets.yml', YAML.dump(fav_tweets)) unless no_unliked
    fav_tweets
  end

  def self.like_mentions(mentions = [])
    mentions += if mentions.empty?
                  Client::C.fav(Client::C.mentions)
                else
                  Client::C.fav(Client::C.mentions(since_id: mentions.last.id))
                end
    # Client::C.fav(mentions)
    File.write('mentions.yml', YAML.dump(mentions))
    mentions
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
