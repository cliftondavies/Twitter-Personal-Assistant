require 'twitter'
require 'yaml'
require_relative '../lib/user.rb'
require_relative '../lib/client.rb'

describe User do
  subject { User.new }

  describe '#username' do
    it 'returns the screen name of user' do
      expect(subject.username).to eql(Client::C.user.screen_name)
    end
  end

  describe '#followers_count' do
    it 'returns total followers the user has' do
      expect(subject.followers_count).to eql(Client::C.user.followers_count)
    end
  end

  describe '#tweets_count' do
    it 'returns total tweets made by user' do
      expect(subject.tweets_count).to eql(Client::C.user.tweets_count)
    end
  end

  let(:test_tweets) { YAML.load_file('tweets_testdata.yml') }

  describe '.store_tweet' do
    context 'when user makes first tweet' do
      it 'returns an array containing first tweet' do
        tweets_record = YAML.load_file('tweets.yml')
        expect(User.store_tweet).to be_an(Array)
        if tweets_record
          File.write('tweets.yml', YAML.dump(tweets_record))
        else
          File.write('tweets.yml', YAML.dump(nil))
        end
      end
    end

    context 'when user makes subsequent tweets' do
      it 'returns an array with subsequent tweets' do
        expect(User.store_tweet(test_tweets)).to be_an(Array) | eql(nil)
      end
    end
  end

  describe '.like_mentions' do
    context 'when user has no mentions stored' do
      it 'returns an array with result of running like_mentions' do
        mentions_record = YAML.load_file('mentions.yml')
        expect(User.like_mentions).to be_an(Array)
        if mentions_record
          File.write('mentions.yml', YAML.dump(mentions_record))
        else
          File.write('mentions.yml', YAML.dump(nil))
        end
      end
    end

    context 'when user has mentions stored' do
      it 'returns an array with result of running like_mentions' do
        test_mentions = YAML.load_file('mentions_testdata.yml')
        expect(User.like_mentions(test_mentions)).to be_an(Array) | eql(nil)
      end
    end
  end

  describe '.retweets_received' do
    it "returns the number of times the user's tweets have been retweeted, as an integer" do
      expect(User.retweets_received(test_tweets)).to be_an(Integer)
    end
  end

  describe '.likes_received' do
    it "returns the number of times the user's tweets have been liked, as an integer" do
      expect(User.likes_received(test_tweets)).to be_an(Integer)
    end
  end
end
