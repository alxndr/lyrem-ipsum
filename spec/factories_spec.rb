require 'spec_helper'

non_idempotent_factories = %i(artist) # TODO artist isn't really idempotent
broken_factories = %i()

def factories_except_for(broken_factories)
  FactoryGirl.factories.map(&:name).reject { |factory_sym| broken_factories.include? factory_sym }
end

describe 'working factories' do
  factories_except_for(broken_factories).each do |factory_sym|
    factory_name = factory_sym.to_s.camelize

    describe "The #{factory_name} factory" do
      let(:first) { FactoryGirl.build factory_sym }

      it 'should be valid' do
        expect(first).to be_valid, first.errors.full_messages.to_sentence
      end

      unless non_idempotent_factories.include? factory_sym
        describe "creating a second #{factory_name}" do
          before do
            first.save # save! ?
          end
          it 'should be valid' do
            second = FactoryGirl.build(factory_sym)
            expect(second).to be_valid, second.errors.full_messages.to_sentence
          end
        end
      end
    end
  end
end
