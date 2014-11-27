FactoryGirl.define do

  factory :artist do
    #fake_data = { albums: %w(debut sophomore swansong sharkjump) }

    #name 'Frank'
    slug 'fz' # TODO should be unique
    #data fake_data.to_json

    #before(:build) do |a|
      #a.stub(:fetch_data_for_artist).and_return fake_data
    #end
  end

end
