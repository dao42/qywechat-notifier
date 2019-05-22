module Qywechat::Notifier::QyAPI
  module Errors
    # 通用异常
    Error = Class.new(StandardError)

    # HTTP 异常，比如请求超时等
    HttpError = Class.new(Error)

    # API 异常，比如返回失败状态码
    class APIError < Error
      attr_reader :errcode, :errmsg

      def initialize(errcode, errmsg)
        @errcode = errcode
        @errmsg = errmsg

        super(format('[%s]: %s', @errcode, @errmsg))
      end
    end
  end
end
