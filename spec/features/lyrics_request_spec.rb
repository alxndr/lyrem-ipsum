require 'spec_helper'

feature 'lyrics' do

  before do
    VCR.use_cassette 'artist_api_responses', record: :once do
      visit '/text-from-lyrics-by/blind-faith/2/sentences'
    end
  end

  it 'has a rel=canonical link' do
    page.source.should match '<link rel="canonical" href="/text-from-lyrics-by/blind-faith" />'
  end

  describe 'analytics' do
    it 'tracks your every movement' do
      expect(page.body).to match 'UA-xxxxx-y'
    end
  end

  describe 'content' do
    it 'includes lyrem' # how to verify random jumble against lyrics w/o touching db

    it 'asks you to type in your favorite band' do
      expect(page).to have_content 'Make filler text from the lyrics of:'
      expect(page).to have_selector 'input#artist[type=text]'
    end
  end

end
