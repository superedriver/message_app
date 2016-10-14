require_relative '../spec_helper.rb'

describe 'Home Controller' do
  it 'GET "/"' do
    get '/'
    expect(last_response).to be_redirect
    follow_redirect!
    expect(last_request.url).to include '/messages/new'
  end

  it 'test 404 error' do
    get '/incorrect_url'

    expect(last_response.status).to eq(404)
    expect(last_response.body).to include('This message has been deleted or has not been created yet. Sorryan, Bro...')
  end
end