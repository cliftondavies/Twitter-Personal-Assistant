require 'twitter'
require 'yaml'
require './lib/user.rb'

describe User do
  let(:tweets) { YAML.load_file('tweets_testdata.yml') }

  describe '.store_tweet' do
    context 'when user makes first tweet' do
      it 'returns an array containing first tweet' do
        expect(User.store_tweet).to be_an(Array)
        tweets = YAML.load_file('tweets.yml')
        tweets.pop
        File.write('tweets.yml', YAML.dump(tweets))
      end
    end

    context 'when user makes subsequent tweets' do
      it 'returns an array with subsequent tweets' do
        expect(User.store_tweet(tweets)).to be_an(Array)
      end
    end
  end

  describe '.like_mentions' do
    context 'when user has no mentions stored' do
      it 'returns an array with result of running like_mentions' do
        expect(User.like_mentions).to be_an(Array)
        mentions = YAML.load_file('mentions.yml')
        mentions.pop
        File.write('mentions.yml', YAML.dump(mentions))
      end
    end

    context 'when user has mentions stored' do
      it 'returns an array with result of running like_mentions' do
        mentions = YAML.load_file('mentions_testdata.yml')
        expect(User.like_mentions(mentions)).to be_an(Array)
      end
    end
  end

  describe '.retweets_received' do
    it "returns the number of times the user's tweets have been retweeted, as an integer" do
      expect(User.retweets_received(tweets)).to be_an(Integer)
    end
  end

  describe '.likes_received' do
    it "returns the number of times the user's tweets have been liked, as an integer" do
      expect(User.likes_received(tweets)).to be_an(Integer)
    end
  end
end
