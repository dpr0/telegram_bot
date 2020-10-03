# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'telegram/bot/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.6.3'
  spec.name          = 'telegram_bot'
  spec.version       = '0.0.1'
  spec.authors       = ['dvitvitskiy']
  spec.email         = ['dvitvitskiy.pro@gmail.com']
  spec.summary       = 'infinity'
  spec.homepage      = 'https://github.com/dpr0/telegram_bot'
  spec.require_paths = ['lib']
  spec.add_dependency 'dotenv'
  spec.add_dependency 'telegram-bot-ruby'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
end
