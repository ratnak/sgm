# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gym, class: Gym do
    name 'testgym'
    website 'www.testgym.com'
  end

end

