# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'sqreen/backport/version'

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
