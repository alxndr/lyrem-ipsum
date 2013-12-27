require 'spec_helper'

describe MusicianNameFinder do

  describe '#look_up' do

    describe 'when passed a name' do

      let(:result) { OpenStruct.new title: 'A Musician &#39;n stuff (band) - Wikipedia, the free encyclopedia' }
      let(:results) { [result] }

      describe 'with a title' do
        it 'should ask google' do
          Google::Search::Web.should_receive(:new).and_return(results)
          MusicianNameFinder.look_up('name')
        end

        it 'should trim title' do
          Google::Search::Web.stub(:new).and_return(results)
          MusicianNameFinder.look_up('name').should == "A Musician 'n stuff"
        end
      end

      describe 'without a title' do
        it 'should raise' do
          Google::Search::Web.should_receive(:new).and_return([])
          expect { MusicianNameFinder.look_up('name') }.to raise_error
        end
      end
    end

    describe 'when not passed a name' do
      it 'should raise' do
        expect { MusicianNameFinder.look_up }.to raise_error
      end
    end

  end

end
