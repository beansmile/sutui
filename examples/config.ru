require 'sutui'

class Hello
  def initialize(app)
  end

  def self.call(env)
    # [ 200, {"Content-Type" => "text/plain"}, ["Hello from Rack!"] ]

    raise "Something went wrong!"
  end
end

use Sutui::Rack::ExceptionNotification, sutui: {
  api_key: ENV['API_KEY'],
  api_secret: ENV['API_SECRET'],
  channel_id: ENV['CHANNEL_ID']
}

run Hello
