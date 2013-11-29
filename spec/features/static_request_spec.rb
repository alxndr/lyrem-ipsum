require 'spec_helper'

describe 'home page' do

  before do
    visit '/'
  end

  describe 'content' do
    it 'asks you to type in your favorite band' do
      page.should have_content 'Jumble me up some lyrics by:'
      page.should have_selector 'input#artist[type=text]'
    end
  end

  describe 'submitting band name' do
    it 'sends you to a new page' do
      VCR.use_cassette 'artist_api_responses', record: :once do
        fill_in 'artist', with: 'blind faith'
        fill_in 'How much text are you looking for?', with: '2'
        choose 'sentences'
        click_button 'do it'
        page.should have_content 'Blind Faith ipsum'
      end
    end
  end

  describe 'analytics' do
    it 'tracks your every movement' do
      page.source.should have_content 'UA-xxxxx-y'
    end
  end

end
