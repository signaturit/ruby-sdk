require 'test/unit'
require 'webmock/test_unit'

require './lib/signaturit_client.rb'

class TestSignaturitClient < Test::Unit::TestCase

    TOKEN = 'a_token'

    def setup
        @client = SignaturitClient.new TOKEN, true
    end

    def test_get_signature
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_signature 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v3/signatures/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_signatures
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_signatures(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/signatures.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_count_signatures
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.count_signatures({:status => 'signed', :since =>'1982-07-27'})

        assert_requested :get, 'https://api.signaturit.com/v3/signatures/count.json?status=signed&since=1982-07-27', :headers => { :Authorization => 'Bearer a_token' }
    end


    def test_get_audit_trail
        stub_request(:any, /.*/).to_return(:body => '')

        @client.download_audit_trail('an_id', 'another_id')

        assert_requested :get, 'https://api.signaturit.com/v3/signatures/an_id/documents/another_id/download/audit_trail', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_signed_document
        stub_request(:any, /.*/).to_return(:body => '')

        @client.download_signed_document('an_id', 'another_id')

        assert_requested :get, 'https://api.signaturit.com/v3/signatures/an_id/documents/another_id/download/signed', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_signature_request
        stub_request(:any, /.*/).to_return(:body => '{}')

        path = File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf')

        @client.create_signature path, 'admin@signatur.it'

        assert_requested :post, 'https://api.signaturit.com/v3/signatures.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_cancel_signature_request
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.cancel_signature 'an_id'

        assert_requested :patch, 'https://api.signaturit.com/v3/signatures/an_id/cancel.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_send_reminder
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.send_signature_reminder 'an_id'

        assert_requested :post, 'https://api.signaturit.com/v3/signatures/an_id/reminder.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_signature_request_multi
        stub_request(:any, /.*/).to_return(:body => '{}')

        paths = [
            File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf'),
            File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf')
        ]

        @client.create_signature paths, 'admin@signatur.it'

        assert_requested :post, 'https://api.signaturit.com/v3/signatures.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_branding
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_branding('an_id')

        assert_requested :get, 'https://api.signaturit.com/v3/brandings/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_brandings
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_brandings

        assert_requested :get, 'https://api.signaturit.com/v3/brandings.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_branding
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.create_branding({})

        assert_requested :post, 'https://api.signaturit.com/v3/brandings.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_update_branding
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.update_branding('an_id', {})

        assert_requested :patch, 'https://api.signaturit.com/v3/brandings/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_templates
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_templates(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/templates.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

end
