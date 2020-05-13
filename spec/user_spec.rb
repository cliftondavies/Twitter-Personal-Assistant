require 'twitter'
require './lib/user.rb'

describe User do
  describe '.store_tweet' do
    context 'when user makes first tweet' do
      it 'returns an array containing first tweet' do
        expect(User.store_tweet).to be_an(Array)
      end
    end

    context 'when user makes subsequent tweets' do
      it 'returns an array with subsequent tweets' do
        tweets = Client::C.user_timeline(Client::C.user.id)
        expect(User.store_tweet(tweets)).to be_an(Array)
      end
    end
  end

  describe 'like_retweets' do
    context 'when user has no favorite tweets' do
      it 'returns an array with result of running like_retweets' do
        tweets = Client::C.user_timeline(Client::C.user.id)
        expect(User.like_retweets(tweets)).to be_an(Array)
      end
    end

    context 'when user has favorite tweets' do
      it 'returns an array with result of running like_retweets' do
        tweets = Client::C.user_timeline(Client::C.user.id)
        fav_tweets = Client::C.favorites(Client::C.user.id)
        expect(User.like_retweets(tweets, fav_tweets)).to be_an(Array)
      end
    end
  end

  describe 'retweets_received' do
    it "returns the number of times the user's tweets have been retweeted, as an integer" do
      tweets = Client::C.user_timeline(Client::C.user.id)
      expect(User.retweets_received(tweets)).to be_an(Integer)
    end
  end
end
