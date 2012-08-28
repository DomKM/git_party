# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :issue do
    title "MyString"
    body "MyText"
    html_url "MyString"
    comments 1
    github_created_at "2012-08-25 20:47:05"
    github_updated_at "2012-08-25 20:47:05"
    assignee "MyString"
    number 1
    creator "MyString"
  end
end
