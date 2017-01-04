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

    def test_get_email
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_email 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v3/emails/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_emails
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_emails(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/emails.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_count_emails
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.count_emails({:status => 'delivered'})

        assert_requested :get, 'https://api.signaturit.com/v3/emails/count.json?status=delivered', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_audit_trail
        stub_request(:any, /.*/).to_return(:body => '')

        @client.download_email_audit_trail('an_id', 'another_id')

        assert_requested :get, 'https://api.signaturit.com/v3/emails/an_id/certificates/another_id/download/audit_trail', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_email
        stub_request(:any, /.*/).to_return(:body => '{}')

        path = File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf')

        @client.create_email path, 'admin@signatur.it', 'a subject', 'a body'

        assert_requested :post, 'https://api.signaturit.com/v3/emails.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_single_sms
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_single_sms 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v3/sms/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_sms
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_sms(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/sms.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_count_sms
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.count_sms({:status => 'delivered'})

        assert_requested :get, 'https://api.signaturit.com/v3/sms/count.json?status=delivered', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_audit_trail
        stub_request(:any, /.*/).to_return(:body => '')

        @client.download_sms_audit_trail('an_id', 'another_id')

        assert_requested :get, 'https://api.signaturit.com/v3/sms/an_id/certificates/another_id/download/audit_trail', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_sms
        stub_request(:any, /.*/).to_return(:body => '{}')

        path = File.join(File.expand_path(File.dirname(__FILE__)), 'file.pdf')

        @client.create_sms path, 'admin@signatur.it', 'a body'

        assert_requested :post, 'https://api.signaturit.com/v3/sms.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_single_subscription
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_subscription 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v3/subscriptions/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_subscriptions
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_subscriptions(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/subscriptions.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_count_subscriptions
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.count_subscriptions()

        assert_requested :get, 'https://api.signaturit.com/v3/subscriptions/count.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_subscriptions
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.create_subscription 'https://www.signaturit.com', 'email_delivered'

        assert_requested :post, 'https://api.signaturit.com/v3/subscriptions.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_update_subscription
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.update_subscription('an_id', {})

        assert_requested :patch, 'https://api.signaturit.com/v3/subscriptions/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_delete_subscription
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.delete_subscription('an_id')

        assert_requested :delete, 'https://api.signaturit.com/v3/subscriptions/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_single_contact
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_contact 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v3/contacts/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_contacts
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_contacts(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/contacts.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_count_contacts
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.count_contacts()

        assert_requested :get, 'https://api.signaturit.com/v3/contacts/count.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_contacts
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.create_contact 'email@domain.com', 'Email'

        assert_requested :post, 'https://api.signaturit.com/v3/contacts.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_update_contact
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.update_contact('an_id', {})

        assert_requested :patch, 'https://api.signaturit.com/v3/contacts/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_delete_contact
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.delete_contact('an_id')

        assert_requested :delete, 'https://api.signaturit.com/v3/contacts/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_single_user
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_user 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v3/team/users/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_users
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_users(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/team/users.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_invite_user
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.invite_user 'email@domain.com', 'admin'

        assert_requested :post, 'https://api.signaturit.com/v3/team/users.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_change_user_role
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.change_user_role('an_id', 'admin')

        assert_requested :patch, 'https://api.signaturit.com/v3/team/users/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_remove_user
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.remove_user('an_id')

        assert_requested :delete, 'https://api.signaturit.com/v3/team/users/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_single_group
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.get_group 'an_id'

        assert_requested :get, 'https://api.signaturit.com/v3/team/groups/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_groups
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_groups(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/team/groups.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_create_groups
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.create_group 'SDKs'

        assert_requested :post, 'https://api.signaturit.com/v3/team/groups.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_update_group
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.update_group('an_id', 'SDK')

        assert_requested :patch, 'https://api.signaturit.com/v3/team/groups/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_delete_group
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.delete_group('an_id')

        assert_requested :delete, 'https://api.signaturit.com/v3/team/groups/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_add_manager_to_group
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.add_manager_to_group 'an_id', 'another_id'

        assert_requested :post, 'https://api.signaturit.com/v3/team/groups/an_id/managers/another_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_remove_manager_from_group
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.remove_manager_from_group 'an_id', 'another_id'

        assert_requested :delete, 'https://api.signaturit.com/v3/team/groups/an_id/managers/another_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_add_member_to_group
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.add_member_to_group 'an_id', 'another_id'

        assert_requested :post, 'https://api.signaturit.com/v3/team/groups/an_id/members/another_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_remove_member_from_group
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.remove_member_from_group 'an_id', 'another_id'

        assert_requested :delete, 'https://api.signaturit.com/v3/team/groups/an_id/members/another_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_get_seats
        stub_request(:any, /.*/).to_return(:body => '[]')

        @client.get_seats(5, 10)

        assert_requested :get, 'https://api.signaturit.com/v3/team/seats.json?limit=5&offset=10', :headers => { :Authorization => 'Bearer a_token' }
    end

    def test_remove_seat
        stub_request(:any, /.*/).to_return(:body => '{}')

        @client.remove_seat('an_id')

        assert_requested :delete, 'https://api.signaturit.com/v3/team/seats/an_id.json', :headers => { :Authorization => 'Bearer a_token' }
    end

end
