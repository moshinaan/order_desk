# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OrderDesk::Requests::GetOrders do
  describe '#call' do
    subject(:result) { described_class.new(client).call(params: params) }

    let(:client) { instance_double(OrderDesk::Client) }
    let(:response) { { 'orders' => [{ 'id' => '1001' }] } }

    context 'when params are not provided' do
      let(:params) { nil }

      before do
        allow(client).to receive(:get).with('orders').and_return(response)
        result
      end

      it 'delegates request to /orders endpoint' do
        expect(client).to have_received(:get).with('orders')
        expect(result).to eq(response)
      end
    end

    context 'when params are provided' do
      let(:params) { { 'since' => '2024-01-01', 'page' => 2 } }

      before do
        allow(client).to receive(:get).with('orders?since=2024-01-01&page=2').and_return(response)
        result
      end

      it 'delegates request to /orders with a query string' do
        expect(client).to have_received(:get).with('orders?since=2024-01-01&page=2')
        expect(result).to eq(response)
      end
    end
  end
end
