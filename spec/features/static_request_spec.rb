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
    before do
      fill_in 'artist', with: 'frank zappa'
      pending 'check just url to be sent to, not send response'
      click_button 'do it'
    end

    it 'sends you to a new page' do
      pending
    end
  end
end
