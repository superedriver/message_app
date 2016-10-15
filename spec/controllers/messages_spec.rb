require_relative '../spec_helper.rb'

describe 'Message Controller' do
  it 'GET "/messages/new"' do
    get '/messages/new'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Enter a message!')
  end

  describe 'GET "/messages"' do
    it 'without messages' do
      get '/messages'
      expect(last_response.body).to include('There aren\'t any messages!')
    end

    it 'with messages' do
      message1 = create(:message)
      message2 = create(:message)

      get '/messages'

      expect(last_response.body).to include('All messages:')
      expect(last_response.body).to include(message1.link)
      expect(last_response.body).to include(message2.link)
    end

    it 'deleted messages don\'t appear in list' do
      message1 = create(:message)
      message2 = create(:message)
      message1.destroy

      get '/messages'

      expect(last_response.body).to include('All messages:')
      expect(last_response.body).not_to include(message1.link)
      expect(last_response.body).to include(message2.link)
    end
  end

  describe 'GET "/messages/:link"' do
    it 'without message' do
      get '/messages/:link'
      expect(last_response.status).to eq(404)
      expect(last_response.body).to include('This message has been deleted or has not been created yet. Sorryan, Bro...')
    end

    it 'without destruction options' do
      message = create(:message)

      get "/messages/#{message.link}"
      expect(last_response.body).to include('Message')
      expect(last_response.body).to include(message.text)
    end

    describe 'with destruction options' do
      describe 'delete_after_views' do
        it 'decrements delete_after_views option' do
          message = create(:message)
          message.create_option(delete_after_views: 2)
          get "/messages/#{message.link}"

          expect(last_response.body).to include(message.text)
          expect(last_response.body).to include('Message will be deleted after 1 views')
          expect(message.reload.option.delete_after_views).to eq(1)
        end

        it 'returns correct message if it was the last view' do
          message = create(:message)
          message.create_option(delete_after_views: 1)
          get "/messages/#{message.link}"

          expect(last_response.body).to include(message.text)
          expect(last_response.body).to include('Message has been deleted.')
        end

        it 'destroys the message if it was the last view' do
          message = create(:message)
          message.create_option(delete_after_views: 1)

          expect {
            get "/messages/#{message.link}"
          }.to change{Message.count}.by(-1)
        end
      end

      describe 'delete_at' do
        it 'returns correct text' do
          message = create(:message)
          message.create_option(delete_at: Time.now + 60*60)
          get "/messages/#{message.link}"

          expect(last_response.body).to include(message.text)
          expect(last_response.body).to include("Message will be deleted #{ message.option.delete_at.utc.strftime('%d-%m-%Y') } at #{ message.option.delete_at.utc.strftime('%H:%M') } UTC.")
        end

        it 'destroys expired messages' do
          message = create(:message)
          message.create_option(delete_at: Time.now - 60*60)
          Rake::Task['message:delete_expired'].invoke

          get "/messages/#{message.link}"
          expect(last_response.status).to eq(404)
          expect(last_response.body).to include('This message has been deleted or has not been created yet. Sorryan, Bro...')
        end
      end

      it 'returns correct description with delete_at and delete_after_views' do
        message = create(:message)
        message.create_option(delete_at: Time.now + 60*60, delete_after_views: 5)
        get "/messages/#{message.link}"

        expect(last_response.body).to include(message.text)
        expect(last_response.body).to include("Message will be deleted #{ message.option.delete_at.utc.strftime('%d-%m-%Y') } at #{ message.option.delete_at.utc.strftime('%H:%M') } UTC.")
        expect(last_response.body).to include('Message will be deleted after 4 views')
      end
    end

    describe 'with password' do
      it 'without destruction options' do
        message = create(:message, password: "pass")

        get "/messages/#{message.link}"

        expect(last_response.body).to include('Message is encrypted!')
        expect(last_response.body).to include('Please, enter a password!')
      end
    end
  end

  describe 'POST "/messages"' do
    describe 'without destruction options' do
      it 'should be redirected to show_path' do
        message = attributes_for(:message)

        post '/messages', message: message

        expect(last_response).to be_redirect
        follow_redirect!
        expect(last_request.url).to include "/messages/#{Message.last.link}"
      end

      it 'should increase Message.count by 1' do
        message = attributes_for(:message)

        expect {
          post '/messages', message: message
        }.to change{Message.count}.by(1)
      end
    end

    describe 'with destruction options' do
      it 'should create Option with delete_after_views' do
        message = attributes_for(:message)

        expect {
          post '/messages', message: message, delete_after_views: 5
        }.to change{Option.count}.by(1)
      end

      it 'should create Option with delete_after_hours' do
        message = attributes_for(:message)

        expect {
          post '/messages', message: message, delete_after_hours: 5
        }.to change{Option.count}.by(1)
      end

      it 'should create Option with delete_after_hours and delete_after_views' do
        message = attributes_for(:message)

        expect {
          post '/messages', message: message, delete_after_hours: 5, delete_after_views: 5
        }.to change{Option.count}.by(1)
      end

      it 'should not create Option with incorrect delete_after_hours and delete_after_views' do
        message = attributes_for(:message)

        expect {
          post '/messages', message: message, delete_after_hours: "q", delete_after_views: "q"
        }.to change{Option.count}.by(0)
      end
    end
  end

  describe 'POST "/messages/:link' do
    it 'should return 404 if link is incorrect' do
      post '/messages/0'
      expect(last_response.status).to eq(404)
      expect(last_response.body).to include('This message has been deleted or has not been created yet. Sorryan, Bro...')
    end

    it 'should be redirected if params[:password] is empty' do
      message = create(:message, password: 'qaz')

      post "/messages/#{message.link}"
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include "/messages/#{Message.last.link}"
    end

    it 'should be redirected if message has not got a password' do
      message = create(:message)

      post "/messages/#{message.link}", password: 'qaz'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include "/messages/#{Message.last.link}"
    end

    it 'should be redirected if message.password != params[:password]' do
      message = create(:message, password: 'qwerty')

      post "/messages/#{message.link}", password: 'qaz'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include "/messages/#{Message.last.link}"
    end

    it 'should be redirected if message.password != params[:password]' do
      message = create(:message, password: 'qwerty')

      post "/messages/#{message.link}", password: message.password
      expect(last_response).not_to be_redirect
      expect(last_response.body).to include('Message')
      expect(last_response.body).to include('Text')
    end
  end
end