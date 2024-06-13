# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/card'

RSpec.describe Card do
  let(:card) { Card.new('2', 'H') }

  describe '#initialize' do
    it 'should respond to rank and suit' do
      expect(card).to respond_to :rank
      expect(card).to respond_to :suit
    end
  end
end
