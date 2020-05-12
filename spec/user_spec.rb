require 'twitter'
require './lib/user.rb'

describe User do
  describe '.store_tweet' do
    context 'when user makes first tweet' do
      it 'returns the file with size greater than zero' do
        expect(User.store_tweet.zero?).not_to eql(true)
      end
    end

    context 'when user makes subsequent tweets' do
      it 'returns the file with size greater than or equal to the previous file' do
        tweet = Client::C.user_timeline(Client::C.user.id, count: 1)
        expect(User.store_tweet(tweet).size).to be >= User.store_tweet.size
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
