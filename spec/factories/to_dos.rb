# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :to_do do
    repo_id 1
    sha "MyString"
    path "MyString"
  end
end
