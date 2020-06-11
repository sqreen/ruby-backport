# frozen_string_literal: true

load 'lib/sqreen/backport/version.rb'

Gem::Specification.new do |s|
  s.name        = 'sqreen-backport'
  s.version     = Sqreen::Backport::VERSION
  s.licenses    = ['Sqreen']
  s.summary     = 'Backports to keep supporting old rubies'
  s.authors     = ['Loic Nageleisen']
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://sqreen.com'
  s.metadata    = {
    'source_code_uri' => 'https://github.com/sqreen/ruby-backport',
  }

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop', '~> 0.50.0'
end
