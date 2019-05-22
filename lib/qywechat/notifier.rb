require 'qywechat/notifier/qy_api'
require "qywechat/notifier/version"

module Qywechat
  module Notifier
    def self.configure
      yield Qywechat::Notifier::QyAPI
    end

    class Error < StandardError; end
  end
end
