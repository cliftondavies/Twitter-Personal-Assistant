#!/usr/bin/env ruby
require 'dotenv/load'
require 'twitter'
require './client.rb'
require 'yaml'

# Initialise Rest client
client = Twitter::REST::Client.new(Client.config)

# Tweet
puts 'Would you like to tweet? Enter y/n'
response = gets.chomp.downcase
if response == 'y'
  puts 'Please type in your tweet'
  tweet = gets.chomp
  client.update(tweet)
  puts 'Tweet successful!'
  puts "Tweet content: #{tweet}"
  puts "No. of characters: #{tweet.length}"
end

# Store tweet
puts 'Storing tweet...'
client.user.tweets_count.zero? ? store_tweet : store_tweet(YAML.load_file('tweets.yml'))

# Like retweets
puts 'Would you like to favorite some retweets of your posts that you have not liked? Enter y/n'
if client.user.tweets_count.zero? || retweets_received.zero?
  puts 'You have not received any retweets'
elsif YAML.load_file('fav_tweets.yml').is_a?(Array)
  like_retweets(YAML.load_file('tweets.yml'), YAML.load_file('fav_tweets.yml'))
else
  like_retweets
end

puts 'Would you like to see your account summary? y/n'
# Total followers
puts "You have #{client.user.followers_count} follower(s)."

# Total tweets
puts "You have tweeted #{client.user.tweets_count} time(s)."

if YAML.load_file('tweets.yml').is_a?(Array)
  # Total retweets received
  puts "#{retweets_received(YAML.load_file('tweets.yml'))} of your tweets have been retweeted."

  # Total likes received
  puts "#{likes_received(YAML.load_file('tweets.yml'))} of your tweets have been liked."
else
  puts 'You have not received any tweet likes or retweets.'
end

# Total retweets liked
if YAML.load_file('fav_tweets.yml').is_a?(Array)
  puts "You have liked #{YAML.load_file('fav_tweets.yml').size} retweets of your tweets"
else
  puts 'You either have not liked, or have not received, any retweets of your tweets'
end
