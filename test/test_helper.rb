# frozen_string_literal: true

require 'bundler/setup'
require 'minitest/autorun'
require 'webmock/minitest'
require_relative '../lib/order_desk'

WebMock.disable_net_connect!(allow_localhost: true)
