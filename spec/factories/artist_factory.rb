FactoryGirl.define do

  factory :artist do
    data_json = {
      'albums' => [
        'debut',
        'sophomore',
        'swan song',
        'shark jump'
      ]
    }.to_json

    name 'bob' #{ |n| "#{Faker::Name.name} #{n}" }
    data data_json
  end

end
