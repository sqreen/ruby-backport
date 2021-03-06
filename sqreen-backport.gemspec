# frozen_string_literal: true

# Copyright (c) 2015 Sqreen. All Rights Reserved.
# Please refer to our terms for more information: https://www.sqreen.com/terms.html

Gem::Specification.new do |s|
  s.name        = 'sqreen-backport'
  s.version     = '0.1.0'
  s.licenses    = ['Sqreen']
  s.summary     = 'Backports to keep supporting old rubies'
  s.authors     = ['Loic Nageleisen']
  s.files       = Dir['lib/**/*.rb'] +
                  ['CHANGELOG.md', 'LICENSE']
  s.homepage    = 'https://sqreen.com'
  s.metadata    = {
    'source_code_uri' => 'https://github.com/sqreen/ruby-backport',
  } unless RUBY_VERSION < '2.0' # 1.9.3 has an old rubygems, only matters for testing

  s.required_ruby_version = '>= 1.9.3'
end
