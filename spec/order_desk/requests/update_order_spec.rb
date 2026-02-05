# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OrderDesk::Requests::UpdateOrder do
  describe '#call' do
    subject(:result) { described_class.new(client).call(order_id:, order:) }

    let(:client) { instance_double(OrderDesk::Client) }
    let(:order_id) { 1001 }
    let(:order) { { 'id' => order_id, 'order_items' => [] } }
    let(:response) { { 'order' => order } }

    before do
      allow(client).to receive(:put).with('orders/1001', body: order).and_return(response)
    end

    it 'delegates request to /orders/:id endpoint with payload' do
      expect(result).to eq(response)
      expect(client).to have_received(:put).with('orders/1001', body: order)
    end
  end
end
