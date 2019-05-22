module Qywechat::Notifier::QyAPI
  module API
    class Message
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def send_groupchat(message)
        client.post('/cgi-bin/appchat/send', params: { access_token: Qywechat::Notifier::QyAPI.api_token.get_access_token }, json: {
          chatid: Qywechat::Notifier::QyAPI.chatid,
          msgtype: 'text',
          text: { content: message },
          safe: 0
        })
      end
    end
  end
end
