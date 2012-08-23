# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sha do
    repo_id 1
    sha "MyString"
    path "MyString"
    content "MyText"
    type ""
  end
end
