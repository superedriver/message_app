namespace :message do
  desc 'Delete all expired messages'
  task :delete_expired do
    puts "-------------------------------"
    puts "Start destroy expired messages"
    Option.where('delete_at <= ?', Time.now).each do |option|
      option.message.destroy
      puts "Message #{option.message.link} destroyed!"
    end
    puts "Finish destroy expired messages"
    puts "-------------------------------"
  end
end
