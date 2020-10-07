# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirtySeed::Assigners::DirtyAssigner do
  describe '#initialize' do
    context 'when arguments are valid' do
      it 'instantiates an instance' do
        expect(described_class.new(validators: [ActiveModel::Validator.new])).to be_a described_class
      end
    end

    context 'when model does not inherit from ActiveRecord::Base' do
      it 'raises an ArgumentError' do
        expect { described_class.new(validators: [Object]) }.to raise_error ArgumentError
      end
    end
  end
end
