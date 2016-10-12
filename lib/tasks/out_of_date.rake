namespace :message do
  desc "Delete all expired messages"
  task :delete do
    Option.where("delete_at <= ?", Time.now).each { |option| option.message.destroy  }
  end
end
