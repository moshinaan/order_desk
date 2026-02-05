# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OrderDesk::Requests::DeleteOrder do
  describe '#call' do
    subject(:result) { described_class.new(client).call(order_id:) }

    let(:client) { instance_double(OrderDesk::Client) }
    let(:order_id) { 1001 }
    let(:response) { { 'message' => 'Order deleted' } }

    before do
      allow(client).to receive(:delete).with('orders/1001').and_return(response)
    end

    it 'delegates request to /orders/:id endpoint' do
      expect(result).to eq(response)
      expect(client).to have_received(:delete).with('orders/1001')
    end
  end
end
