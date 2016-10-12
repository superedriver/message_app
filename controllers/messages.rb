get '/messages' do
  @messages = Message.all
  haml :'message/index'
end

get '/messages/new' do
  haml :'message/new'
end

get '/messages/:link' do
  @message = Message.find_by(link: params[:link])

  # binding.pry
  # @message.text = AESCrypt.decrypt(@message.text, @message.password) if @message.password.present?
  if @message
    if @message.password.present?
      haml :'message/encrypted'
    else
      @message = update_message(@message) if @message.option && @message.option.delete_after_views
      haml :'message/show'
    end

  else
    "This message has been deleted or has not been created yet. Sorryan, Bro..."
  end
end

post "/messages" do
  message = Message.new(params[:message])

  message.link = SecureRandom.urlsafe_base64(8)
  message.password = params[:password]
  # message.password = SecureRandom.hex(8)
  # message.text = AESCrypt.encrypt(message.text, message.password) if params[:password].present?

  if message.save
    delete_after_views = convert_views(params[:delete_after_views])
    delete_at = convert_hours(params[:delete_after_hours])

    message.create_option(delete_at: delete_at, delete_after_views: delete_after_views) if delete_after_views || delete_at

    redirect "/messages/#{message.link}"
  else
    "There was a error while creating the message!"
  end
end

post "/messages/password" do
  binding.pry
  @message = Message.find_by(link: params[:link])

  if @message.password == params[:password]

    # format.js {  haml :"/message/show" }

    # respond_to do |wants|
    #   wants.html { haml :'message/show' }
    #   wants.js { haml :'message/show' }
    # end
    # content_type 'text/javascript'
    # Turns views/new_game.erb into a string
    haml :'message/show1'
  else
    redirect "/messages/#{@message.link}"
  end
end

private

def convert_views(views)
  return nil if views.nil? || views.to_i <= 0
  views.to_i
end

def convert_hours(hours)
  return nil if hours.nil? || hours.to_i <= 0
  Time.current + hours.to_i * 60 * 60
end

def update_message(message)
  message.option.delete_after_views -=1
  message.option.save
  message.destroy if message.option.delete_after_views <= 0
  message
end
