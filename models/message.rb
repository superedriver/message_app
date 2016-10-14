class Message < ActiveRecord::Base
  has_one :option, dependent: :destroy

  def correct_password?(password)
    self.password == password
  end

  def get_link
    self.link = SecureRandom.urlsafe_base64(8)
  end
end