require_relative '../spec_helper.rb'

describe 'manage messages', type: :feature do
  context 'create not encoded messages' do
    before do
      Timecop.freeze(Time.now)
    end

    after do
      Timecop.return
    end

    scenario 'without destroy options' do
      message = attributes_for(:message)
      visit '/'

      fill_in 'message[text]',  with: message[:text]
      click_button 'Create Message'

      expect(page).to have_content message[:text]
    end

    context 'with destroy options' do
      scenario 'delete_after_views' do
        message = attributes_for(:message, delete_after_views: 5)

        visit '/'
        fill_in 'message[text]',  with: message[:text]
        fill_in 'delete_after_views',  with: message[:delete_after_views]
        click_button 'Create Message'

        expect(page).to have_content message[:text]
        expect(page).to have_content "Message will be deleted after #{message[:delete_after_views] - 1} views"
      end

      scenario 'delete_at' do
        message = attributes_for(:message)
        delete_after_hours = 1

        visit '/'
        fill_in 'message[text]',  with: message[:text]
        fill_in 'delete_after_hours',  with: delete_after_hours
        click_button 'Create Message'

        time = Time.now + delete_after_hours * 60 *60

        expect(page).to have_content message[:text]
        expect(page).to have_content "Message will be deleted #{ time.utc.strftime('%d-%m-%Y') } at #{ time.utc.strftime('%H:%M') } UTC."
      end

      scenario 'delete_after_views with delete_at' do
        message = attributes_for(:message, delete_after_views: 5)
        delete_after_hours = 1

        visit '/'
        fill_in 'message[text]',  with: message[:text]
        fill_in 'delete_after_hours',  with: delete_after_hours
        fill_in 'delete_after_views',  with: message[:delete_after_views]
        click_button 'Create Message'

        time = Time.now + delete_after_hours * 60 *60

        expect(page).to have_content message[:text]
        expect(page).to have_content "Message will be deleted #{ time.utc.strftime('%d-%m-%Y') } at #{ time.utc.strftime('%H:%M') } UTC."
        expect(page).to have_content "Message will be deleted after #{message[:delete_after_views] - 1} views"
      end
    end
  end

  context 'create encoded messages' do
    scenario 'page should have correct content after creation' do
      message = attributes_for(:message)
      password = 'pass'

      visit '/'

      fill_in 'message[text]',  with: message[:text]
      fill_in 'password',  with: password
      click_button 'Create Message'

      expect(page).to have_content 'Message is encrypted!'
      expect(page).to have_content 'Please, enter a password!'
      expect(page).to have_field 'password'
      expect(page).not_to have_content message[:text]
    end

    scenario 'should ask password to show the message' do
      password = 'pass'
      message = create(:message, password: password)

      visit "messages/#{message.link}"

      expect(page).to have_content 'Message is encrypted!'
      expect(page).to have_content 'Please, enter a password!'
      expect(page).to have_field 'password'
      expect(page).not_to have_content message[:text]
    end

  end
  context 'password confirmation for show message' do
    scenario 'should not show message text if incorrect password' do
      password = 'pass'
      message = create(:message, password: password)

      visit "messages/#{message.link}"
      fill_in 'password',  with: password + '1'
      click_button 'Check password'

      expect(page).to have_content 'Message is encrypted!'
      expect(page).to have_content 'Please, enter a password!'
      expect(page).to have_field 'password'
      expect(page).not_to have_content message[:text]
    end

    scenario 'should not show message text if correct password' do
      password = 'pass'
      message = create(:message, password: password)

      visit "messages/#{message.link}"
      fill_in 'password',  with: password
      click_button 'Check password'

      expect(page).to have_content message[:text]
    end
  end
end
