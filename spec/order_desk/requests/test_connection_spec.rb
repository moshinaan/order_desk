# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OrderDesk::Requests::TestConnection do
  describe '#call' do
    subject(:result) { described_class.new(client).call }

    let(:client) { instance_double(OrderDesk::Client) }
    let(:response) { { 'status' => 'success' } }

    before do
      allow(client).to receive(:get).with('test').and_return(response)
      result
    end

    it 'delegates request to /test endpoint' do
      expect(client).to have_received(:get).with('test')
      expect(result).to eq(response)
    end
  end
end
