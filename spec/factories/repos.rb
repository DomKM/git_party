# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repo do
    name "MyString"
    owner_id 1
  end
end
