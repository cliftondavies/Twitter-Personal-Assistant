require 'dotenv/load'
require 'twitter'
require 'yaml'

module Bot
  def self.store_tweet(tweets = [])
    tweets += client.user_timeline('qualitycodebot', count: 1)
    File.write('tweets.yml', YAML.dump(tweets))
  end

  def self.like_retweets(tweets, fav_tweets = [])
    tweets.each do |twit|
      unliked_tweets = client.retweets(twit) - fav_tweets
      fav_tweets += client.fav(unliked_tweets) unless unliked_tweets.size.zero?
    end
    File.write('fav_tweets.yml', YAML.dump(fav_tweets)) unless fav_tweets.empty?
  end
end
