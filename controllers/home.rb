get '/' do
  redirect '/messages/new'
end

get '/:name' do
  "Hello, #{params[:name]}!"
end
