helpers MessageHelper

get '/messages' do
  @messages = Message.all
  haml :'/message/index'
end

get '/messages/new' do
  haml :'/message/new'
end

get '/messages/:link' do
  @message = Message.find_by(link: params[:link])
  halt 404, message_not_found unless @message

  if @message.password.present?
    haml :'/message/encrypted'
  else
    @message = update_message(@message) if @message&.option&.delete_after_views
    haml :'/message/show'
  end
end

post '/messages' do
  message = Message.new(params[:message])

  message.link = SecureRandom.urlsafe_base64(8)
  message.password = params[:password]

  if message.save
    delete_after_views = convert_views(params[:delete_after_views])
    delete_at = convert_hours(params[:delete_after_hours])

    message.create_option(delete_at: delete_at, delete_after_views: delete_after_views) if delete_after_views || delete_at

    redirect "/messages/#{message.link}"
  else
    'There was a error while creating the message!'
  end
end

post '/messages/:link' do
  @message = Message.find_by(link: params[:link])
  halt 404, message_not_found unless @message

  if @message.correct_password? params[:password]
     @message = update_message(@message) if @message&.option&.delete_after_views
    haml :'/message/show'
  else
    redirect "/messages/#{@message.link}"
  end
end
