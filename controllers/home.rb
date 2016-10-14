get '/' do
  redirect '/messages/new'
end

not_found do
  halt 404, haml(:'/message/404')
end