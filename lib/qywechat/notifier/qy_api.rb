require 'qywechat/notifier/qy_api/client'
require 'qywechat/notifier/qy_api/errors'
require 'qywechat/notifier/qy_api/api/message'
require 'qywechat/notifier/qy_api/api/token'

module Qywechat
  module Notifier
    module QyAPI
      def self.api_token
        @api_token ||= QyAPI::API::Token.new
      end

      def self.api_message
        @api_message ||= QyAPI::API::Message.new
      end

      mattr_accessor :corpid, :chatid, :corpsecret
    end
  end
end
