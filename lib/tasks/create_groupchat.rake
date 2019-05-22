require 'qywechat/notifier'

task create_groupchat: :environment do
  raise '请先填写群 ID' unless Qywechat::Notifier::QyAPI.chatid.present?
  puts('请输入群聊名:')
  name = STDIN.gets().gsub(/\r\n|\n/, '')
  raise '群聊名不能为空' unless name.present?
  puts('请输入群主名:')
  owner = STDIN.gets().gsub(/\r\n|\n/, '')
  raise '群主名不能为空' unless owner.present?
  puts('请输入一个群员名(额外的群员可在新创建的群内直接添加):')
  username = STDIN.gets().gsub(/\r\n|\n/, '')
  raise '群员名不能为空' unless username.present?
  userlist = [owner, username]

  client = Qywechat::Notifier::QyAPI::Client.new
  client.post('/cgi-bin/appchat/create', params: { access_token: Qywechat::Notifier::QyAPI.api_token.get_access_token }, json: {
    chatid: Qywechat::Notifier::QyAPI.chatid,
    name: name,
    owner: owner,
    userlist: userlist
  })
  Qywechat::Notifier::QyAPI.api_message.send_groupchat('create groupchat ok')
end
