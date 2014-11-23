FactoryGirl.define do

  factory :artist do
    fake_data = { albums: %w(debut sophomore swansong sharkjump) }

    name 'Frank'
    slug 'fz'
    data fake_data.to_json
  end

end
