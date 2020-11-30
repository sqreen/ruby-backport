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
  }

  s.required_ruby_version = '>= 2.0'
end
