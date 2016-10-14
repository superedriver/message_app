FactoryGirl.define do
  factory :option do
    delete_at nil
    delete_after_views nil
    association :message
  end
end