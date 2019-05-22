module Qywechat::Notifier::QyAPI
  module API
    class Token
      attr_reader :client

      def initialize
        @client = Client.new
      end

      def get_access_token
        Rails.cache.fetch('exception_notifier::qy_wechat_notifier', expires_in: 6800.seconds) do
          refresh_access_token
        end
      end

      private

      def refresh_access_token
        res = client.get('/cgi-bin/gettoken', params: { corpid: Qywechat::Notifier::QyAPI.corpid, corpsecret: Qywechat::Notifier::QyAPI.corpsecret })
        res["access_token"]
      end
    end
  end
end
