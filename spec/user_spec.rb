require 'twitter'
require './lib/user.rb'

describe User do
  describe '.store_tweet' do
    context 'when user has only tweeted once' do
      it 'returns an array containing one tweet' do
        expect(User.store_tweet.size).to eql(1)
      end
    end

    context 'when user makes subsequent tweets' do
      it 'returns an array containing more than one tweet' do
        tweet = Client::C.user_timeline(Client::C.user.id, count: 1)
        expect(User.store_tweet(tweet).size).to be > 1
      end
    end
  end

  describe 'like_retweets' do
    it 'returns retweets that have been liked' do
      tweet = Client::C.user_timeline(Client::C.user.id, count: 1)
      expect(User.like_retweets(tweet, tweet).size).to eql(tweet.first.retweet_count)
    end
  end
end
