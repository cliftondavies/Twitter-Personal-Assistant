#!/usr/bin/env ruby
require 'dotenv/load'
require 'twitter'
require 'yaml'
require './lib/client.rb'
require './lib/user.rb'

# Tweet
puts "Would you like to tweet? Enter 'y' for 'yes', or press any other key to skip"
response = gets.chomp.downcase
if response == 'y'
  puts 'Please type in your tweet'
  tweet = gets.chomp
  Client::C.update(tweet)
  puts 'Tweet successful!'
  puts "Tweet content: #{tweet}"
  puts "No. of characters: #{tweet.length}"
  # Store tweet
  puts 'Storing tweet...'
  Client::C.user.tweets_count == 1 ? User.store_tweet : User.store_tweet(YAML.load_file('tweets.yml'))
else
  puts 'Borrring... You have chosen not to tweet!'
end

# Like retweets
puts 'Would you like to favorite some retweets of your posts that you have not liked?'
puts "Enter 'y' for 'yes', or press any other key to skip"
reply = gets.chomp.downcase
if reply == 'y'
  # binding.pry
  if Client::C.user.tweets_count.zero? || User.retweets_received(YAML.load_file('tweets.yml')).zero?
    puts 'You have not received any retweets'
  elsif YAML.load_file('fav_tweets.yml').is_a?(Array)
    User.like_retweets(YAML.load_file('tweets.yml'), YAML.load_file('fav_tweets.yml'))
  else
    User.like_retweets(YAML.load_file('tweets.yml'))
  end
else
  puts 'Nooo?! Your retweeters will be disaapointed.'
end

puts 'Would you like to see your account summary?'
puts "Enter 'y' for 'yes', or press any other key to skip"
choice = gets.chomp.downcase
if choice == 'y'
  # Total followers
  puts "You have #{Client::C.user.followers_count} follower(s)."

  # Total tweets
  puts "You have tweeted #{Client::C.user.tweets_count} time(s)."

  if YAML.load_file('tweets.yml').is_a?(Array)
    # Total retweets received
    puts "#{User.retweets_received(YAML.load_file('tweets.yml'))} of your tweets have been retweeted."

    # Total likes received
    puts "Your tweets has been liked #{User.likes_received(YAML.load_file('tweets.yml'))} time(s)."
  else
    puts 'You have not received any tweet likes or retweets.'
  end

  # Total retweets liked
  if YAML.load_file('fav_tweets.yml').is_a?(Array)
    puts "You have liked #{YAML.load_file('fav_tweets.yml').size} retweet(s) of your tweets"
  else
    puts 'You either have not liked, or have not received, any retweets of your tweets'
  end
else
  puts 'The stats will be here when you need them.'
end
