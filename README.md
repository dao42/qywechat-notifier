# Qywechat::Notifier

为你的 Rails 应用添加企业微信异常监控。

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'qywechat-notifier', github: 'dao42/qywechat-notifier'
```

And then execute:

    $ bundle

## Usage

### 创建群聊会话

系统提供了 Rake 命令，帮助快速创建一个会话

```bash
$ rails create_groupchat
```

请按照引导创建群聊，创建成功后系统会发送一条消息，初始至少需要一位群主和一位群员。后续可手动去企业微信APP中添加其他成员。

记录好 CHATID。

### 配置

创建配置文件，并修改配置项。

```ruby
# config/initializers/qywechat_notifier.rb
Qywechat::Notifier.configure do |config|
  config.corpid = 'yourcorpid'
  config.corpsecret = 'yourcorpsecret'
  config.chatid = 'yourchatid'
end
```

各参数配置的含义:

CORPID: 参见[说明](https://work.weixin.qq.com/api/doc#90000/90135/90665)

CORPSECRET: 参见[说明](https://work.weixin.qq.com/api/doc#90000/90135/90665)

CHATID: 上面用 Rake 命令创建的群聊ID，参见[说明](https://work.weixin.qq.com/api/doc#90000/90135/90245)

### 配置 exception_notification，启用插件

```ruby
# config/initializers/exception_notification.rb
require 'exception_notification/rails'
require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  ...
  ...
  config.add_notifier :qy_wechat, {}
end
```

### 完成

到此，所有 Rails 应用异常都可以发送到群聊之中了。

## 定制异常内容

额外异常内容，可写入 `request.env['exception_notifier.exception_data']` 中，如：

```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base

  # 增加以下内容
  before_action :prepare_exception_notifier

  private
  def prepare_exception_notifier
    request.env['exception_notifier.exception_data'] = {
      current_user: current_user&.id
    }
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/qywechat-notifier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Qywechat::Notifier project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/qywechat-notifier/blob/master/CODE_OF_CONDUCT.md).
