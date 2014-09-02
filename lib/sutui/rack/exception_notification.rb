module Sutui
  module Rack
    class ExceptionNotification
      class << self
        attr_accessor :config
      end

      def initialize(app, options)
        ExceptionNotifier.configure options[:sutui]

        @app = app
      end

      def call(env)
        @app.call(env)
      rescue Exception => e
        ExceptionNotifier.notify(e, env)

        raise e
      end
    end
  end
end
