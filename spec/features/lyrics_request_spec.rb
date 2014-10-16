require 'spec_helper'

describe 'lyrics', type: :request do

  before do
    VCR.use_cassette 'artist_api_responses', record: :once do
      get '/text-from-lyrics-by/blind-faith/2/sentences'
    end
  end

  it 'has a rel=canonical link' do
    page.source.should include '<link rel="canonical" href="/text-from-lyrics-by/blind-faith" />'
  end

  describe 'analytics' do
    it 'tracks your every movement' do
      page.body.should have_content 'UA-xxxxx-y'
    end
  end

  describe 'content' do
    it 'includes lyrem' do
      pending 'how to verify random jumble against lyrics w/o touching db'
    end

    it 'asks you to type in your favorite band' do
      page.should have_content ''
      page.should have_selector 'input#artist[type=text]'
    end
  end

end
