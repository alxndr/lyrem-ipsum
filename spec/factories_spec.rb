require 'spec_helper'

non_idempotent_factories = []
broken_factories = []

FactoryGirl.factories.map(&:name).reject{|factory_sym| broken_factories.include? factory_sym}.each do |factory_sym|
  factory_name = factory_sym.to_s.camelize

  describe "The #{factory_name} factory" do
    let(:first) { FactoryGirl.build factory_sym }

    it 'should be valid' do
      expect(first).to be_valid?, first.errors.full_messages.to_sentence
    end

    describe "creating a second #{factory_name}" do
      before do
        first.save
      end
      it 'should be valid' do
        second = FactoryGirl.build(factory_sym)
        expect(second).to be_valid?, second.errors.full_messages.to_sentence
      end
    end unless non_idempotent_factories.include? factory_sym
  end
end
