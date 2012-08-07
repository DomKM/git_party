# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repo do
    name { Faker::Internet.domain_word }
    owner { Faker::Internet.user_name }
  end
end
