require 'test/unit'

require 'webmock/test_unit'

require './lib/signaturit_client.rb'

class TestSignaturitClient < Test::Unit::TestCase

    TOKEN = 'a_token'

    def setup
        @client = SignaturitClient.new TOKEN, true
    end

    def test_get_account
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_account()

        assert_requested :get, 'https://api.signaturit.com/v2/account.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_set_document_storage
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.set_document_storage('sftp', {})

        assert_requested :post, 'https://api.signaturit.com/v2/account/storage.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_revert_to_default_document_storage
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.revert_to_default_document_storage()

        assert_requested :delete, 'https://api.signaturit.com/v2/account/storage.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_signature
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_signature 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v2/signs/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_signatures
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_signatures(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v2/signs.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_count_signatures
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.count_signatures('signed', '1982-07-27')

        assert_requested :get, 'https://api.signaturit.com/v2/signs/count.json?status=signed&since=1982-07-27', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_signature_document
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_signature_document('an_id', 'another_id')

        assert_requested :get, 'https://api.signaturit.com/v2/signs/an_id/documents/another_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_signature_documents
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_signature_documents('an_id')

        assert_requested :get, 'https://api.signaturit.com/v2/signs/an_id/documents.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_audit_trail
        stub_request(:any, /.*/).to_return(:body => '')

        @client.get_audit_trail('an_id', 'another_id', Tempfile.new('pdf').path)

        assert_requested :get, 'https://api.signaturit.com/v2/signs/an_id/documents/another_id/download/doc_proof', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_signed_document
        stub_request(:any, /.*/).to_return(:body => '')

        @client.get_signed_document('an_id', 'another_id', Tempfile.new('pdf').path)

        assert_requested :get, 'https://api.signaturit.com/v2/signs/an_id/documents/another_id/download/signed', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_signature_request
        stub_request(:any, /.*/).to_return(:body => '{}')

        path = File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf')

        @client.create_signature_request(path, 'admin@signatur.it')

        assert_requested :post, 'https://api.signaturit.com/v2/signs.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_signature_request_multi
        stub_request(:any, /.*/).to_return(:body => '{}')

        paths = [
            File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf'),
            File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf')
        ]

        @client.create_signature_request(paths, 'admin@signatur.it')

        assert_requested :post, 'https://api.signaturit.com/v2/signs.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_branding
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_branding('an_id')

        assert_requested :get, 'https://api.signaturit.com/v2/brandings/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_brandings
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_brandings()

        assert_requested :get, 'https://api.signaturit.com/v2/brandings.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_branding
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.create_branding({})

        assert_requested :post, 'https://api.signaturit.com/v2/brandings.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_update_branding
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.update_branding('an_id', {})

        assert_requested :patch, 'https://api.signaturit.com/v2/brandings/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_update_branding_logo
        stub_request(:any, /.*/).to_return(:body => '{}')

        path = File.join(File.expand_path(File.dirname(__FILE__)), 'file.png')

        @client.update_branding_logo('an_id', path)

        assert_requested :put, 'https://api.signaturit.com/v2/brandings/an_id/logo.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_update_branding_template
        stub_request(:any, /.*/).to_return(:body => '{}')

        path = File.join(File.expand_path(File.dirname(__FILE__)), 'file.html')

        @client.update_branding_template('an_id', 'a_template', path)

        assert_requested :put, 'https://api.signaturit.com/v2/brandings/an_id/emails/a_template.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_templates
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_templates(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v2/templates.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end
end
