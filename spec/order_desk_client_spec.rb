# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OrderDesk::Client do
  let(:store_id) { 'store_123' }
  let(:api_key) { 'api_key_abc' }
  let(:base_url) { 'https://app.orderdesk.me/api/v2/' }

  subject(:client) do
    described_class.new(store_id: store_id, api_key: api_key, base_url: base_url)
  end

  describe '#order_properties' do
    it 'keeps only order-property fields from the docs list' do
      stub_request(:get, 'https://app.orderdesk.me/api/v2/orders/1001')
        .to_return(
          status: 200,
          body: {
            order: {
              'id' => '1001',
              'email' => 'buyer@example.com',
              'total' => '49.99',
              'custom_field' => 'raw'
            }
          }.to_json
        )

      expect(client.order_properties(1001)).to eq(
        'id' => '1001',
        'email' => 'buyer@example.com',
        'total' => '49.99'
      )
    end
  end

  describe 'error handling' do
    it 'raises AuthenticationError on 401' do
      stub_request(:get, 'https://app.orderdesk.me/api/v2/test')
        .to_return(status: 401, body: { status: 'error' }.to_json)

      expect { client.test_connection }
        .to raise_error(OrderDesk::AuthenticationError)
    end

    it 'raises RateLimitError with retry-after' do
      stub_request(:get, 'https://app.orderdesk.me/api/v2/test')
        .to_return(status: 429, headers: { 'Retry-After' => '10' }, body: '')

      expect { client.test_connection }
        .to raise_error(OrderDesk::RateLimitError) { |error| expect(error.retry_after).to eq(10) }
    end
  end
end
