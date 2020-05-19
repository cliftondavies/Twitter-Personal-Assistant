require 'twitter'
require_relative '../lib/client.rb'

describe Client do
  describe '.config' do
    it 'returns the client config info in the form of a hash' do
      expect(Client.config.keys).to eql(%i[consumer_key consumer_secret access_token access_token_secret])
    end
  end
end
