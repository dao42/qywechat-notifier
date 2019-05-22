require 'qywechat/notifier'

module ExceptionNotifier
  class QyWechatNotifier < BaseNotifier
    def initialize(options)
      super
    end

    def call(exception, options={})
      env = options[:env]
      pp 111, exception

      if env.present?
        # 这里是外部请求导致的异常
        request = ActionDispatch::Request.new(env)
        request_items = {
          url: request.original_url,
          http_method: request.method,
          ip_address: request.remote_ip,
          parameters: request.filtered_parameters,
          timestamp: Time.current.strftime('%Y-%m-%d %H:%M:%S')
        }

        message = <<-EOF
Exception>>> #{exception.class.to_s}: #{exception.message.inspect}
URL>>> #{request_items[:http_method]}: #{request_items[:url]}( from: #{request_items[:ip_address]} )
PARAM>>> #{request_items[:parameters]}
Agent>>> #{request.filtered_env['HTTP_USER_AGENT']}
Data>>> #{env && env['exception_notifier.exception_data']}
------------
Backtrace( 5 below )>>>\n
#{exception.backtrace[0..4].join("\n")}
        EOF

        Qywechat::Notifier::QyAPI.api_message.send_groupchat(message)
      else
        # 内部异常, 例如 sidekiq 任务
        message = <<-EOF
Exception>>> #{exception.class.to_s}: #{exception.message.inspect}
OPTIONS>>> \n
#{options.to_yaml}
------------
Backtrace( 5 below )>>>\n
#{exception.backtrace[0..4].join("\n")}
        EOF

        Qywechat::Notifier::QyAPI.api_message.send_groupchat(message)
      end
    end
  end
end
