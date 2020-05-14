#!/usr/bin/env ruby
require 'dotenv/load'
require 'twitter'
require 'yaml'
require './lib/client.rb'
require './lib/user.rb'

puts "
------
TWEET
------
Q: Would you like to tweet?
>> Enter 'y' for 'yes', or press any other key to skip
"
response = gets.chomp.downcase
puts ' '
if response == 'y'
  puts '>> Please type in your tweet
  '
  tweet = gets.chomp
  while tweet.length > 280
    puts '
    >> Please reduce number of characters to 280 or less.
    '
    tweet = gets.chomp
  end
  Client::C.update(tweet)
  puts '
  | Tweet successful! |
  '
  sleep 1
  puts "| You tweeted: #{tweet} |
  "
  sleep 1
  puts "| Your tweet was #{tweet.length} characters long. |
  "
  sleep 1
  puts '| Storing tweet... |
  '
  sleep 2
  if YAML.load_file('tweets.yml').is_a?(Array)
    User.store_tweet(YAML.load_file('tweets.yml'))
  else
    User.store_tweet
  end
  puts 'Done!'
else
  puts '| Borrring... You have chosen not to tweet! |'
end

puts "
-------------
LIKE MENTIONS
-------------
Q: Would you like to favorite some tweets that mentioned you?
>> Enter 'y' for 'yes', or press any other key to skip
"
reply = gets.chomp.downcase
puts ' '
if reply == 'y'
  puts '| Checking for mentions... |
  '
  if YAML.load_file('mentions.yml').is_a?(Array)
    User.like_mentions(YAML.load_file('mentions.yml'))
  else
    User.like_mentions
  end
  sleep 2
  puts 'Done.'
else
  puts '| Nooo?! Those who mentioned you will be disappointed. |'
end

puts "
---------------
ACCOUNT SUMMARY
---------------
Q: Would you like to see your account summary?
>> Enter 'y' for 'yes', or press any other key to skip
"
choice = gets.chomp.downcase
puts ' '
if choice == 'y'
  puts "| Total Followers: |
  You have #{Client::C.user.followers_count} follower(s).
  "
  sleep 2
  puts "| Total Tweets: |
  You have tweeted #{Client::C.user.tweets_count} time(s).
  "
  sleep 2
  if YAML.load_file('tweets.yml').is_a?(Array)
    puts "| Total Retweets Received Since Setup: |
    Your tweets have been retweeted #{User.retweets_received(YAML.load_file('tweets.yml'))} time(s).
    "
    sleep 2
    puts "| Total Likes Received Since Setup: |
    Your tweets have been liked #{User.likes_received(YAML.load_file('tweets.yml'))} time(s).
    "
  else
    puts '| You have not received any tweet likes or retweets. |
    '
  end
  sleep 2
  if YAML.load_file('mentions.yml').is_a?(Array)
    puts "| Total Mentions Liked Since Setup: |
    You have liked #{YAML.load_file('mentions.yml').size} mention(s) of your tweets.
    "
  else
    puts '| You either have not liked, or have not received, any tweet mentions. |'
  end
else
  puts '| The stats will be here when you need them. |'
end
