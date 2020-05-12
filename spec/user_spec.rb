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
    context 'when user has not liked any retweets' do
      it '' do
        expect
      end
    end

    context 'when user has liked at least one retweet' do
      it '' do
        expect
      end
    end
  end
end
