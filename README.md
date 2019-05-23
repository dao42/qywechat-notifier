# Qywechat::Notifier

引用 exception_notifier 向企业微信发送异常通知。

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qywechat-notifier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qywechat-notifier

## Usage

在 `config/initializers` 新建配置文件 `qrwechat_notifier.rb`, 并配置 [CORPID](https://work.weixin.qq.com/api/doc#90000/90135/90665)、[CORPSECRET](https://work.weixin.qq.com/api/doc#90000/90135/90665)、[CHATID](https://work.weixin.qq.com/api/doc#90000/90135/90665)。

    Qywechat::Notifier.configure do |config|
      config.corpid = ''
      config.chatid = ''
      config.corpsecret = ''
    end


其中`CHATID`可自定义组合`0-9` `a-z` `A-Z`, 配置后可通过:

    $ rake create_groupchat

按照引导生成群聊，并向群聊发送一条消息，初始有一位群主和一位群员。后续可在企业微信内添加额外成员。


另在 `config/initializers/exception_notification.rb` 需要配置

    require 'exception_notification/rails'
    require 'exception_notification/sidekiq'

    ExceptionNotification.configure do |config|

      ...

      config.add_notifier :qy_wechat, {}
    end

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/qywechat-notifier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Qywechat::Notifier project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/qywechat-notifier/blob/master/CODE_OF_CONDUCT.md).
