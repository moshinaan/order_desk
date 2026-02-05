# Order Desk Ruby Integration

A minimal Ruby client for Order Desk API v2 with focus on order properties.

## Setup

```bash
bundle install
bundle exec rake test
```

## Environment variables

```bash
export ORDERDESK_STORE_ID="your-store-id"
export ORDERDESK_API_KEY="your-api-key"
```

## Usage

```ruby
require 'order_desk'

client = OrderDesk::Client.new(
  store_id: ENV.fetch('ORDERDESK_STORE_ID'),
  api_key: ENV.fetch('ORDERDESK_API_KEY')
)

client.test_connection
order = client.get_order(1001)
orders = client.get_orders(params: { since: '2024-01-01', page: 1 })
updated_order = client.update_order(1001, order: { order_id: 1001, order_items: [] })
delete_response = client.delete_order(1001)


puts order
puts orders
puts updated_order
puts delete_response
puts properties
```

## Notes

- Base URL defaults to `https://app.orderdesk.me/api/v2`.
- Auth headers are `ORDERDESK-STORE-ID` and `ORDERDESK-API-KEY`.
- Updating an order requires sending the complete order payload (fields omitted are cleared).
