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

    before do
      Artist.stub(:new).and_return FactoryGirl.build_stubbed :artist
    end

    it 'sends you to a new page' do
      VCR.use_cassette 'artist_search_and_lyrics', record: :none do

        fill_in 'artist', with: 'phish'
        fill_in 'How much text are you looking for?', with: '2'
        choose 'sentences'
        click_button 'do it'

        expect(page).to have_content 'Lorem ipsum from Phish lyrics'
      end
    end

  end

  describe 'analytics' do
    it 'is on the page' do
      expect(page.source).to match 'UA-xxxxx-y'
    end
  end

end
