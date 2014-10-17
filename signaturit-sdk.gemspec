Gem::Specification.new do |s|
    s.platform    = Gem::Platform::RUBY
    s.name        = 'signaturit-sdk'
    s.version     = '0.0.3'
    s.date        = '2014-10-17'
    s.summary     = 'Signaturit Ruby SDK'
    s.description = 'Sign Documents Online'

    s.author      = 'Signaturit'
    s.email       = 'api@signaturit.com'
    s.homepage    = 'https://signaturit.com/'

    s.files       = `git ls-files`.split($/)
    s.test_files  = s.files.grep(%r{^test})

    s.license     = 'MIT'

    s.add_dependency 'rest_client', '~> 1.7.3'

    s.add_development_dependency 'webmock', '~> 1.18.0'
end
