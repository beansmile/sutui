# encoding: utf-8

require 'digest'
require 'json'
require 'typhoeus'

module Sutui
  class SutuiSDK
    attr_accessor :api_key, :api_secret, :api_host, :rest_client, :digest_agent

    API_HOST = 'http://api.sutui.me'

    def initialize(api_key, api_secret, api_host = API_HOST)
      self.api_key = api_key
      self.api_secret = api_secret
      self.api_host = api_host

      self.rest_client = Typhoeus
      self.digest_agent = Digest::SHA1.new
    end

    # TODO: verify this method
    def subscribe(user_id, channel_id, unsubscribe = false)
      data = {
        user_id: user_id,
        channel_id: channel_id,
        unsubscribe: unsubscribe ? 1 : 0
      }

      response = rest_client.post(signature_url('/subscription/'), body: data)
      process_response(response)
    end

    def unsubscribe(subscription_id)
      response = rest_client.delete(signature_url("/subscription/#{sid}/"))
      process_response(response)
    end

    # TODO: verify this method
    def subscriptions(user_id)
      response = rest_client.get(signature_url("/subscription/?user_id=#{user_id}"))
      process_response(response)
    end

    def channels
      response = rest_client.get(signature_url('/channel/'))
      process_response(response)
    end

    def create_channel(channel_name)
      data = {name: channel_name}
      response = rest_client.post(signature_url("/channel/"), body: data)
      process_response(response)
    end

    def remove_channel(channel_id)
      response = rest_client.delete(signature_url("/channel/#{channel_id}/"))
      process_response(response)
    end

    def notify(channel_id, msg_type, message)
      data = {
        channel_id: channel_id,
        msg_type: msg_type,
        content: message
      }
      headers = {'Content-Type' => 'application/json'}
      response = rest_client.post(signature_url('/message/'), body: data.to_json, headers: headers)
      process_response(response)
    end

    def commands(channel_id)
      params = {}
      params['channel'] = channel_id if channel_id

      response = rest_client.get(signature_url('/command/'), body: params)
      process_response(response)
    end

    def create_command(channel_id, command, url, description = nil, override = true)
      data = {
        channel_id: channel_id,
        command: command,
        url: url,
        description: description,
        override: override
      }
      response = rest_client.post(signature_url('/command/'), body: data)
      process_response(response)
    end

    # TODO: verify this method
    def update_command(command_id, channel_id, command=nil, url=nil, description=nil)
      data = {
        channel_id: channel_id,
        command: command,
        url: url,
        description: description
      }
      response = rest_client.put(signature_url("/command/#{command_id}/"), body: data)
      process_response response
    end

    def remove_command(command_id)
      response = rest_client.delete(signature_url("/command/#{command_id}/"))

      process_response response
    end

    private
    def signature_url(url)
      if url.include? '?'
        url += '&'
      else
        url += '?'
      end

      timestamp = '%10.5f' % Time.now.to_f
      key = "api.key=#{api_key}"
      ts = "api.timestamp=#{timestamp}"

      digest = digest_agent.hexdigest [api_key, api_secret, timestamp].join('&')
      signature = "api.signature=#{digest}"

      api_host + url + [key, ts, signature].join('&')
    end

    def process_response(response)
      if response.code == 200
        json_response = JSON.parse response.body
        json_response.include?('errno') && json_response['errno'] != 0 ? nil : json_response
      elsif response.code == 403
        json_response = JSON.parse response.body
        raise AuthenticationError, "#{response.status_message}: #{json_response['detail']}"
      end
    end
  end
end
