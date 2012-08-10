# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo_line do
    todo_file_id 1
    line_num 1
  end
end
