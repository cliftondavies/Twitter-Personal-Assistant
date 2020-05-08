require 'dotenv/load'
require 'twitter'
require 'yaml'

module Bot
  def self.store_tweet(tweets = [])
    tweets += client.user_timeline('qualitycodebot', count: 1)
    File.write('tweets.yml', YAML.dump(tweets))
  end
end
