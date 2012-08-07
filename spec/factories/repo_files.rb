# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repo_file do
    path "MyString"
    repo_id 1
  end
end
