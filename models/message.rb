class Message < ActiveRecord::Base
  has_one :option, dependent: :destroy

  def correct_password?(password)
    self.password == password
  end
end