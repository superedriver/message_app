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
  halt 404, haml(:'/message/404') unless @message

  if @message.password.present?
    haml :'/message/encrypted'
  else
    @message = update_message(@message)
    haml :'/message/show'
  end
end

post '/messages' do
  message = Message.new(params[:message])
  message.password = params[:password]
  message.get_link

  if message.save
    delete_after_views = convert_views(params[:delete_after_views])
    delete_at = convert_hours(params[:delete_after_hours])

    message.create_option(delete_at: delete_at, delete_after_views: delete_after_views) if delete_after_views || delete_at

    redirect "/messages/#{message.link}"
  else
    'There was an error while creating the message!'
  end
end

post '/messages/:link' do
  @message = Message.find_by(link: params[:link])
  halt 404, haml(:'/message/404') unless @message

  if @message.password.present? && params[:password].present? && @message.correct_password?(params[:password])
     @message = update_message(@message)
    haml :'/message/show'
  else
    redirect "/messages/#{@message.link}"
  end
end
