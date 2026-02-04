# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OrderDesk::Requests::GetOrder do
  describe '#call' do
    subject(:result) { described_class.new(client).call(order_id:) }
    let(:client) { instance_double(OrderDesk::Client) }
    let(:response) { { 'order' => { 'id' => order_id.to_s } } }
    let(:order_id) { 1001 }

    before do
      allow(client).to receive(:get).with('orders/1001').and_return(response)
      result
    end

    it 'delegates request to /orders/:id endpoint' do
      expect(client).to have_received(:get).with('orders/1001')
      expect(result).to eq(response)
    end
  end
end
