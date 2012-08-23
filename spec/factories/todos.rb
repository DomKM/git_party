# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :to_do do
    sha { SecureRandom.hex }
    path { Faker::Product.brand + "/" + Faker::Product.brand + "." + ('a'..'z').to_a.shuffle.pop(2)}
    repo
  end
end