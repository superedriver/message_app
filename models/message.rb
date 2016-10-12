class Message < ActiveRecord::Base
  has_one :option, dependent: :destroy
end