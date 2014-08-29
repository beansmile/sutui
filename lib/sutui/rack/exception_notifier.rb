module Sutui
  module Rack
    class ExceptionNotifier
      class << self
        attr_accessor :sutui_sdk, :channel_id
      end

      def self.configure(config = {})
        self.sutui_sdk = Sutui::SutuiSDK.new config[:api_key], config[:api_secret]
        self.channel_id = config[:channel_id]
      end

      def self.notify(exception, env_options)
        message = ""
        message << "message: #{exception.message}\n"
        message << "file: #{exception.backtrace.first}\n"
        message << "host: #{env_options["HTTP_HOST"]}\n"
        message << "request path: #{env_options["REQUEST_PATH"]}"

        sutui_sdk.notify(channel_id, 'text', message)
      end
    end
  end
end
