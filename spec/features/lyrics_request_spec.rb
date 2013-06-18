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
      page.body.should have_content 'UA-xxxxx-y'
    end
  end

  describe 'content' do
    it 'includes lyrem' do
      pending 'something up with stubbing'
    end

    it 'asks you to type in your favorite band' do
      page.should have_content 'Jumble me up some lyrics by:'
      page.should have_selector 'input#artist[type=text]'
    end
  end

end