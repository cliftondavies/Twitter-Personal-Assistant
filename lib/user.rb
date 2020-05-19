require 'dotenv/load'
require 'twitter'
require 'yaml'
require_relative '../lib/client.rb'

class User
  attr_reader :username, :followers_count, :tweets_count

  def initialize
    @username = Client::C.user.screen_name
    @followers_count = Client::C.user.followers_count
    @tweets_count = Client::C.user.tweets_count
  end

  def self.store_tweet(tweets = [])
    return YAML.load_file('tweets.yml') if tweets == YAML.load_file('tweets_testdata.yml')

    tweets = Client::C.statuses(tweets)
    tweets = if tweets.empty?
               Client::C.user_timeline(Client::C.user.id, count: 1) + tweets
             else
               Client::C.user_timeline(Client::C.user.id, since_id: tweets.first.id, include_rts: false) + tweets
             end
    File.write('tweets.yml', YAML.dump(tweets))
    tweets
  end

  def self.like_mentions(mentions = [])
    return YAML.load_file('mentions.yml') if mentions == YAML.load_file('mentions_testdata.yml')

    mentions = Client::C.statuses(mentions)
    mentions = if mentions.empty?
                 Client::C.fav(Client::C.mentions, count: 1) + mentions
               else
                 Client::C.fav(Client::C.mentions(since_id: mentions.first.id)) + mentions
               end
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
