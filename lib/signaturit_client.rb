# Load rest client
require 'rest_client'

# Load json
require 'json'

# Signaturit client class
class SignaturitClient
    # Initialize the object with the token and environment
    def initialize(token, production = false)
        base = production ? 'https://api.signaturit.com' : 'http://api.sandbox.signaturit.com'

        @client = RestClient::Resource.new base, :headers => { :Authorization => "Bearer #{token}", :user_agent => 'signaturit-ruby-sdk 0.0.4' }, :ssl_version => :TLSv1_2
    end

    # get info from your account
    def get_account
        request :get, '/v2/account.json'
    end

    # Get a concrete signature object
    #
    # Params:
    # +signature_id+:: The id of the signature object
    def get_signature(signature_id)
        request :get, "/v2/signs/#{signature_id}.json"
    end

    # Get a list of signature objects
    #
    # Params:
    # +limit+:: Maximum number of results to return
    # +offset+:: Offset of results to skip
    # +conditions+:: Filter conditions
    def get_signatures(limit = 100, offset = 0, conditions = {})
        params = extract_query_params conditions

        params['limit']  = limit
        params['offset'] = offset

        request :get, '/v2/signs.json', params
    end

    # Get the number of signature objects
    #
    # Params:
    # +conditions+:: Filter conditions
    def count_signatures(conditions = {})
        params = extract_query_params conditions

        request :get, '/v2/signs/count.json', params
    end

    # Get a concrete document from a concrete Signature
    #
    # Params:
    # +signature_id+:: The id of the signature object
    # +document_id+:: The id of the document object
    def get_signature_document(signature_id, document_id)
        request :get, "/v2/signs/#{signature_id}/documents/#{document_id}.json"
    end

    # Get all documents in the given signature object
    #
    # Params:
    # +signature_id+:: The id of the signature object
    def get_signature_documents(signature_id)
        request :get, "/v2/signs/#{signature_id}/documents.json"
    end

    # Get the audit trail of concrete document
    #
    # Params:
    # +signature_id++:: The id of the signature object
    # +document_id++:: The id of the document object
    # +path++:: Path where the document will be stored
    def download_audit_trail(signature_id, document_id, path)
        response = request :get, "/v2/signs/#{signature_id}/documents/#{document_id}/download/doc_proof", {}, false

        File.open(path, 'wb') do |file|
            file.write(response)
        end

        nil
    end

    # Get the signed document
    #
    # Params:
    # +signature_id++:: The id of the signature object
    # +document_id++:: The id of the document object
    # +path++:: Path where the document will be stored
    def download_signed_document(signature_id, document_id, path)
        response = request :get, "/v2/signs/#{signature_id}/documents/#{document_id}/download/signed", {}, false

        File.open(path, 'wb') do |file|
            file.write(response)
        end

        nil
    end

    # Create a new Signature request
    #
    # Params:
    # +filepath+:: The pdf file to send or an array with multiple files.
    # +recipients+:: A string with an email, a hash like
    # {:name => "a name", :email => "me@domain.com", :phone => "34655123456"}
    # or an array of hashes.
    # +params+:: An array of parameters for the signature object
    #   - subject: Subject of the email
    #   - body: Body of the email
    #   - in_person: If you want to do an in person sign (system will not send
    #   an email to the user, but return the signature url instead)
    #   - sequential: If you want to do a sequential sign (for multiple
    #   recipients, the sign goes in sequential way)
    #   - photo: If a photo is required in sign process
    #   - mandatory_pages: An array with the pages the signer must sign
    #   - branding_id: The id of the branding you want to use
    #   - templates: An array ot template ids to use.
    def create_signature(filepath, recipients, params = {})
        params[:recipients] = {}

        [recipients].flatten.each_with_index do |recipient, index|
            params[:recipients][index] = recipient
        end

        params[:files] = [filepath].flatten.map do |filepath|
            File.new(filepath, 'rb')
        end

        params[:templates] = [params[:templates]].flatten if params[:templates]

        request :post, '/v2/signs.json', params
    end

    # Cancel a signature request
    #
    # Params
    # +signature_id++:: The id of the signature object
    def cancel_signature(signature_id)
        request :patch, "/v2/signs/#{signature_id}/cancel.json"
    end

    # Send a reminder for the given signature request document
    #
    # Param
    # +signature_id++:: The id of the signature object
    # +document_id++:: The id of the document object
    def send_signature_reminder(signature_id, document_id)
        request :post, "/v2/signs/#{signature_id}/documents/#{document_id}/reminder.json"
    end

    # Get a concrete branding
    #
    # Params
    # +branding_id+:: The id of the branding object
    def get_branding(branding_id)
        request :get, "/v2/brandings/#{branding_id}.json"
    end

    # Get all account brandings
    def get_brandings
        request :get, '/v2/brandings.json'
    end

    # Create a new branding
    #
    # Params:
    # +params+:: An array of parameters for the branding object
    #   - primary: If set, this new branding will be the default one
    #   - corporate_layout_color: Default color for all application widgets
    #   - corporate_text_color: Default text color for all application widgets
    #   - application_texts: A dict with the new text values
    #     - sign_button: Text for sign button
    #     - send_button: Text for send button
    #     - decline_button: Text for decline button:
    #     - decline_modal_title: Title for decline modal
    #     - decline_modal_body: Body for decline modal
    #     - photo: Photo message text, which tells the user that a photo is
    #       needed in the current process
    #     - multi_pages: Header of the document, which tells the user the
    #       number of pages to sign
    #   - subject_tag: This tag appears at the subject of all your messages
    #   - reminders: A list with reminder times (in seconds). Every reminder
    #   time, a email will be sent, if the signer didn't sign the document
    #   - expire_time: The signature time (in seconds). When the expire time is
    #   over, the document cannot be signed. Set 0 if you want a signature
    #   without expire time.
    #   - callback_url: A url to redirect the user, when the process is over.
    #   - signature_pos_x: Default position x of signature
    #   - signature_pos_y: Default position y of signature
    #   - terms_and_conditions_label: The terms text that appears when you need
    #   to check the button to accept.
    #   - terms_and_conditions_body: Custom text that appears below signature
    #   conditions
    #   - hide_legal_section: If true, legal section in email footer doesn't
    #   appear
    #   - hide_info_section: If true, info section in email footer doesn't
    #   appear
    #   - hide_contact_section: If true, contact section in email footer
    #   doesn't appear
    def create_branding(params)
        request :post, '/v2/brandings.json', params
    end

    # Update a existing branding
    #
    # Params:
    # +branding_id+:: Id of the branding to update
    # +params+:: Same params as method create_branding, see above
    def update_branding(branding_id, params)
        request :patch, "/v2/brandings/#{branding_id}.json", params
    end

    # Update the logo of a branding
    #
    # Params:
    # +branding_id+:: Id of the branding to update
    # +filepath+:: The path to the image file
    def update_branding_logo(branding_id, filepath)
        request :put, "/v2/brandings/#{branding_id}/logo.json", File.read(filepath)
    end

    # Update the email of a branding
    #
    # Params:
    # +branding_id+:: Id of the branding to update
    # +filepath+:: The path to the html file
    # +template+:: The email template trying to update
    def update_branding_email(branding_id, template, filepath)
        request :put, "/v2/brandings/#{branding_id}/emails/#{template}.json", File.read(filepath)
    end

    # Get a list of template objects
    #
    # Params:
    # +limit+:: Maximum number of results to return
    # +offset+:: Offset of results to skip
    def get_templates(limit = 100, offset = 0)
        params = { :limit => limit, :offset => offset }

        request :get, '/v2/templates.json', params
    end

    # Get all emails
    #
    # Params:
    # +limit+:: Maximum number of results to return
    # +offset+:: Offset of results to skip
    # +conditions+:: Query conditions
    def get_emails(limit = 100, offset = 0, conditions = {})
        params = extract_query_params conditions

        params['limit']  = limit
        params['offset'] = offset

        request :get, '/v3/emails.json', params
    end

    # Count all emails
    #
    # Params:
    # +conditions+:: Query conditions
    def count_emails(conditions = {})
        params = extract_query_params conditions

        request :get, '/v3/emails/count.json', params
    end

    # Get a single email
    #
    # Params:
    # +email_id+:: Id of email
    def get_email(email_id)
        request :get, "/v3/emails/#{email_id}.json"
    end

    # Get a single email certificates
    #
    # Params:
    # +email_id+:: Id of email
    def get_email_certificates(email_id)
        request :get, "/v3/emails/#{email_id}/certificates.json"
    end

    # Get a single email certificate
    #
    # Params:
    # +email_id+:: Id of email
    # +certificate_id+:: Id of certificate
    def get_email_certificate(email_id, certificate_id)
        request :get, "/v3/emails/#{email_id}/certificates/#{certificate_id}.json"
    end

    # Create a new email
    #
    # Params:
    # +files+:: File or files to send with the email
    # +recipients+:: Recipients for the email
    # +subject+:: Email subject
    # +body+:: Email body
    # +params+:: Extra params
    def create_email(files, recipients, subject, body, params = {})
        params[:recipients] = {}

        [recipients].flatten.each_with_index do |recipient, index|
            params[:recipients][index] = recipient
        end

        params[:files] = [files].flatten.map do |filepath|
            File.new(filepath, 'rb')
        end

        params[:subject] = subject
        params[:body]    = body

        request :post, '/v3/signs.json', params
    end

    # Get the audit trail of concrete certificate
    #
    # Params:
    # +email_id++:: The id of the signature object
    # +certificate_id++:: The id of the document object
    # +path++:: Path where the document will be stored
    def download_email_audit_trail(email_id, certificate_id, path)
        response = request :get, "/v3/emails/#{email_id}/certificates/#{certificate_id}/download/audit_trail", {}, false

        File.open(path, 'wb') do |file|
            file.write(response)
        end

        nil
    end

    # Get the original file of concrete certificate
    #
    # Params:
    # +email_id++:: The id of the signature object
    # +certificate_id++:: The id of the document object
    # +path++:: Path where the document will be stored
    def download_email_original_file(email_id, certificate_id, path)
        response = request :get, "/v3/emails/#{email_id}/certificates/#{certificate_id}/download/original", {}, false

        File.open(path, 'wb') do |file|
            file.write(response)
        end

        nil
    end

    # PRIVATE METHODS FROM HERE

    private
    def extract_query_params(conditions)
        params = {}

        conditions.each do |key, value|
            if key == 'data'
                value.each do|data_key, data_value|
                    params[key][data_key] = data_value
                end

                continue
            end

            if key == 'ids'
                value = value.join(',')
            end

            params[key] = value
        end

        params
    end

    # Common request method
    private
    def request(method, path, params = {}, to_json = true)
        case method
            when :get, :delete
                encoded = URI.encode_www_form(params)

                path = "#{path}?#{encoded}" if encoded.length > 0

                body = @client[path].send method

            else
                body = @client[path].send method, params
        end

        body = JSON.parse body if to_json

        body
    end
end
