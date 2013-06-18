require 'spec_helper'

describe 'lyrics' do

  before do
    stub_request(:get, 'http://lyrics.wikia.com/api.php?artist=fz&fmt=realjson&func=getArtist').
      to_return(status: 200, body: "{artist: 'Frank Zappa'}", headers: {})

    pending 'something up with stubbing'
    visit '/text-from-lyrics-by/fz'
  end

  it 'has a rel=canonical link' do
    page.should have_selector 'link[rel=canonical][href=/text-from-lyrics-by/frank-zappa]'
  end

  describe 'analytics' do
    it 'tracks your every movement' do
      pending
    end
  end

end