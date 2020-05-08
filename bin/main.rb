#!/usr/bin/env ruby
require 'dotenv/load'
require 'twitter'
require './client.rb'
require 'yaml'

# Initialise Rest client
client = Twitter::REST::Client.new(Client.config) # do |config|
#   config.consumer_key = ENV['API_KEY']
#   config.consumer_secret = ENV['API_KEY_SECRET']
#   config.access_token = ENV['ACCESS_TOKEN']
#   config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
# end

# Initialiase Streaming client
# streaming_client = Twitter::Streaming::Client.new do |config|
#   config.consumer_key = ENV['API_KEY']
#   config.consumer_secret = ENV['API_KEY_SECRET']
#   config.access_token = ENV['ACCESS_TOKEN']
#   config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
# end

# Send a tweet
puts 'Would you like to tweet? Enter y/n'
response = gets.chomp.downcase
if response == 'y'
  puts 'Please type in your tweet'
  tweet = gets.chomp
  client.update(tweet)
  puts "You tweeted #{tweet.length} characters."
end

# Add tweet to record if tweet was made --refactor --def store_tweet(tweets = [])
# if first tweet record -- when client.user.tweets_count.zero? call store_tweet
tweets = client.user_timeline('qualitycodebot', count: 1)
File.write('tweets.yml', YAML.dump(tweets))

# if subsequent tweet record
tweets = YAML.load_file('tweets.yml')
tweets << client.user_timeline('qualitycodebot', count: 1).first
File.write('tweets.yml', YAML.dump(tweets))

# Count retweets --refactor --def count(tweets, count_choice)
tweets = YAML.load_file('tweets.yml')
tweets.reduce(0) { |sum, twit| sum + twit.retweet_count }

# Count tweet likes received
tweets = YAML.load_file('tweets.yml')
tweets.reduce(0) { |sum, twit| sum + twit.favorite_count }

# Shows account status
puts "You have tweeted #{client.user.tweets_count} time(s)."
puts "You have #{client.user.followers_count} follower(s)."
# puts "You tweets have been liked #{client.user.favourites_count} time(s)."

# Like a retweet --def like_retweets(tweets, fav_tweets = [])
tweets = YAML.load_file('tweets.yml')
fav_tweets = [] # put in parameter
tweets.each do |twit|
  unliked_tweets = client.retweets(twit) - fav_tweets
  fav_tweets += client.fav(unliked_tweets)
end
File.write('fav_tweets.yml', YAML.dump(fav_tweets)) # should i put this in new method called store_fav_tweets(fav_tweets)?

# count retweet likes given --def retweets_liked(fav_tweets)
fav_tweets = YAML.load_file('fav_tweets.yml')
fav_tweets.size

# client.user_timeline('qualitycodebot').each do |obj|
#   puts obj.favorite_count
# end

# streaming_client.user do |object|
#   puts object.retweet_count if object.is_a?(Twitter::Tweet)
# end
