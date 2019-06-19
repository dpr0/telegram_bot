lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'telegram/bot/version'

Gem::Specification.new do |spec|
  spec.name          = 'telegram_bot'
  spec.version       = Telegram::Bot::VERSION
  spec.authors       = ['dvitvitskiy']
  spec.email         = ['dvitvitskiy.pro@gmail.com']

  spec.summary       = 'branch_protector'
  spec.homepage      = 'https://git.github.com/branch-telegram_bot'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dotenv'
  spec.add_dependency 'faraday'
  spec.add_dependency 'virtus'
  spec.add_dependency 'inflecto'
  spec.add_dependency 'socksify'
  spec.add_dependency 'rest-client'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
end
