require 'dotenv/load'

class Client
  C = Twitter::REST::Client.new(config)

  private

  def config
    {
      consumer_key: ENV['API_KEY'],
      consumer_secret: ENV['API_KEY_SECRET'],
      access_token: ENV['ACCESS_TOKEN'],
      access_token_secret: ENV['ACCESS_TOKEN_SECRET']
    }
  end
end

# module Client
#   def self.config
#     {
#       consumer_key: ENV['API_KEY'],
#       consumer_secret: ENV['API_KEY_SECRET'],
#       access_token: ENV['ACCESS_TOKEN'],
#       access_token_secret: ENV['ACCESS_TOKEN_SECRET']
#     }
#   end

#   C = Twitter::REST::Client.new(config)
# end
