require 'spec_helper'

describe MusicianNameFinder do

  describe '#look_up' do

    describe 'when passed a name' do

      let(:result) { OpenStruct.new title: 'A Musician - Wikipedia, the free encyclopedia' }
      let(:results) { [result] }

      it 'should ask google and trim title' do
        Google::Search::Web.should_receive(:new).and_return(results)
        MusicianNameFinder.look_up('name').should == 'A Musician'
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
