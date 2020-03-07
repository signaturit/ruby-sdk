# frozen_string_literal: true

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name        = 'signaturit-sdk'
  s.version     = '1.2.0'
  s.date        = '2016-01-20'
  s.summary     = 'Signaturit Ruby SDK'
  s.description = 'Sign Documents Online'

  s.author      = 'Signaturit'
  s.email       = 'api@signaturit.com'
  s.homepage    = 'https://signaturit.com/'

  s.files       = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.test_files  = s.files.grep(/^test/)

  s.license     = 'MIT'

  s.add_dependency 'rest-client', '~> 2.0'

  s.add_development_dependency 'webmock', '~> 3.0'
end
