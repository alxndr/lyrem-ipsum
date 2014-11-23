require 'spec_helper'

feature 'home page' do

  before do
    visit '/'
  end

  describe 'content' do
    it 'asks you to type in your favorite band' do
      expect(page).to have_content 'Make filler text from the lyrics of:'
      expect(page).to have_selector 'input#artist[type=text]'
    end
  end

  describe 'submitting band name' do
    VCR.use_cassette 'artist_api_responses', record: :once do
      it 'sends you to a new page' do
        fill_in 'artist', with: 'blind faith'
        fill_in 'How much text are you looking for?', with: '2'
        choose 'sentences'
        click_button 'do it'

        expect(page).to have_content 'Lorem ipsum from Blind Faith lyrics'
      end
    end
  end

  describe 'analytics' do
    it 'is on the page' do
      page.source.should match 'UA-xxxxx-y'
    end
  end

end
