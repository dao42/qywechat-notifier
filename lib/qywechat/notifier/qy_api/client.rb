module Qywechat
  module Notifier
    module QyAPI
      class Client
        SERVER_SCHEME = 'https'.freeze
        SERVER_HOST = 'qyapi.weixin.qq.com'.freeze

        def get(path, options = {})
          request(:get, path, options)
        end

        def post(path, options = {})
          request(:post, path, options)
        end

        private

        def request(verb, path, options = {})
          uri = uri_for(path)
          options = options.with_indifferent_access

          options['headers'] ||= {}
          if options['headers']['Content-Type'].blank?
            options['headers']['Content-Type'] = 'application/json'
          end

          begin
            response = HTTP.request(verb, uri, options)
          rescue HTTP::Error => ex
            raise Errors::HttpError, ex.message
          end

          unless response.status.success?
            raise Errors::APIError.new(nil, response.to_s)
          end

          parse_response(response) do |parse_as, result|
            case parse_as
            when :json
              break result if result[:errcode].blank? || result[:errcode].zero?
              raise Errors::APIError.new(result[:errcode], result[:errmsg])
            else
              result
            end
          end
        end

        def uri_for(path)
          uri_options = {
            scheme: SERVER_SCHEME,
            host: SERVER_HOST,
            path: path
          }
          Addressable::URI.new(uri_options)
        end

        def parse_response(response)
          content_type = response.headers[:content_type]
          parse_as = {
            %r{^application\/json} => :json,
            %r{^image\/.*} => :file,
            %r{^text\/html} => :xml,
            %r{^text\/plain} => :plain
          }.each_with_object([]) { |match, memo| memo << match[1] if content_type =~ match[0] }.first || :plain

          if parse_as == :plain
            result = ActiveSupport::JSON.decode(response.body.to_s).with_indifferent_access rescue nil
            if result
              return yield(:json, result)
            else
              return yield(:plain, response.body)
            end
          end

          case parse_as
          when :json
            result = ActiveSupport::JSON.decode(response.body.to_s).with_indifferent_access
          when :file
            if %r{^image\/.*}.match?(response.headers[:content_type])
              extension =
                case response.headers['content-type']
                when 'image/gif'  then '.gif'
                when 'image/jpeg' then '.jpg'
                when 'image/png'  then '.png'
                end
            else
              extension = ''
            end

            begin
              file = Tempfile.new(['wxapi-file-', extension])
              file.binmode
              file.write(response.body)
            ensure
              file&.close
            end

            result = file
          when :xml
            result = Hash.from_xml(response.body.to_s)
          else
            result = response.body
          end

          yield(parse_as, result)
        end
      end
    end
  end
end
