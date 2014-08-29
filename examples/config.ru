require File.expand_path('lib/sutui')

class Hello
  def initialize(app)
  end

  def self.call(env)
    # [ 200, {"Content-Type" => "text/plain"}, ["Hello from Rack!"] ]

    raise "Something went wrong!"
  end
end

use Sutui::Rack::ExceptionNotification, sutui: {
  api_key: 'api_key_here',
  api_secret: 'api_secret_here',
  channel_id: 12
}

run Hello
