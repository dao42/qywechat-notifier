class Qywechat::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/create_groupchat.rake'
  end
end
