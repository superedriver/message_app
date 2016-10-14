FactoryGirl.define do
  factory :message do
    text Faker::Lorem.sentence
    sequence(:link){|n| "#{Faker::Crypto.md5 + n.to_s}" }
    password nil
  end
end