# frozen_string_literal: true

require_relative 'lib/order_desk/version'

Gem::Specification.new do |spec|
  spec.name = 'order_desk'
  spec.version = OrderDesk::VERSION
  spec.authors = ['Order Desk']
  spec.email = ['support@orderdesk.me']

  spec.summary = 'Ruby client for Order Desk API v2.'
  spec.description = 'A minimal Ruby client for Order Desk API v2 with focus on order properties.'
  spec.homepage = 'https://github.com/order-desk/order-desk-ruby'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    Dir['lib/**/*', 'README.md', 'LICENSE*', 'Gemfile', 'Rakefile']
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock'
end
