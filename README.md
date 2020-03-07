[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=signaturit_ruby-sdk&metric=alert_status&token=121c3b6aa0fac2a6963c3536b38edc3a9e4bf8ab)](https://sonarcloud.io/dashboard?id=signaturit_ruby-sdk)

========================
DO NOT USE MASTER BRANCH
========================

Signaturit Ruby SDK
===================

This package is a wrapper for Signaturit Api. If you didn't read the documentation yet, maybe it's time to take a look [here](https://docs.signaturit.com/).

You can install the package through gem.

```
gem install signaturit-sdk
```

Configuration
-------------

Just import the Signaturit Client this way

```
require 'signaturit_client'
```

Then you can authenticate yourself using your AuthToken

```
client = SignaturitClient.new('TOKEN')
```

Remember, the default calls are made to our Sandbox server. If you want to do in production, just set the flag when you do the call.

```
client = SignaturitClient.new('TOKEN', true)
```

Examples
--------

## Signature request

### Get all signature requests

Retrieve all data from your signature requests using different filters.

##### All signatures

```
response = client.get_signatures
```

##### Getting the last 50 signatures

```
response = client.get_signatures 50
```

##### Getting the following last 50 signatures

```
response = client.get_signatures 50, 50
```

##### Getting only the finished signatures

```
response = client.get_signatures 100, 0, {:status => 'completed'}
```

##### Getting the finished signatures created since July 20th of 2014

```
response = client.get_signatures 100, 0, 3, {:since => '2014-7-20'}
```

##### Getting signatures with custom field "crm_id"

```
response = client.get_signatures 100, 0, {:crm_id => 2445}
```

### Count signature requests

Count your signature requests.

```
response = client.count_signatures
```

### Get signature request

Get a single signature request.

```
response = client.get_signature 'SIGNATURE_ID'
```

### Signature request

Create a new signature request. You can check all signature [params](https://docs.signaturit.com/api/v3#sign_create_sign).

```
recipients =  ['bobsoap@signatur.it']
params = {:subject: 'Receipt number 250', :body: 'Please, can you sign this document?'}
file_path = '/documents/contracts/125932_important.pdf'
response = client.create_signature file_path, recipients, params
```

You can send templates with the fields filled

```
recipients =  ['bobsoap@signatur.it']
params = {:subject =>  'Receipt number 250', :body => 'Please, can you sign this document?', :templates =>  {'TEMPLATE_ID'}, :data => {:WIDGET_ID => 'DEFAULT_VALUE'}}

response = client.create_signature {}, recipients, params
```

You can add custom info in your requests

```
recipients =  ['bobsoap@signatur.it']
params = {:subject =>  'Receipt number 250', :body => 'Please, can you sign this document?', :data => {:crm_id => 2445}}
file_path = '/documents/contracts/125932_important.pdf'
response = client.create_signature file_path, recipients, params
```

### Cancel signature request

Cancel a signature request.

```
response = client.cancel_signature 'SIGNATURE_ID'
```

### Send reminder

Send a reminder for signature request job.

```
response = client.send_signature_reminder 'SIGNATURE_ID'
```

### Get audit trail

Get the audit trail of a signature request document

```
response = client.download_audit_trail 'ID', 'DOCUMENT_ID'
```

### Get signed document

Get the signed document of a signature request document

```
response = client.download_signed_document 'ID', 'DOCUMENT_ID'
```

## Branding

### Get brandings

Get all account brandings.

```
response = client.get_brandings
```

### Get branding

Get a single branding.

```
response = client.get_branding 'BRANDING_ID'
```

### Create branding

Create a new branding. You can check all branding [params](https://docs.signaturit.com/api/v3#set_branding).`

```
params = {
    :layout_color: '#FFBF00',
    :text_color: '#2A1B0A',
    :application_texts: { :sign_button: 'Sign!' }
}
response = client.create_branding params
```

### Update branding

Update a single branding.

```
params = { :application_texts: { :send_button: 'Send!' } }
response = client.update_branding 'BRANDING_ID', params
```

## Template

### Get all templates

Retrieve all data from your templates.

```
response = client.get_templates
```

## Email

### Get emails

####Get all certified emails

```
response = client.get_emails
```

####Get last 50 emails

```
response = client.get_emails 50
```

####Navigate through all emails in blocks of 50 results

```
response = client.get_emails 50, 50
```

### Count emails

Count all certified emails

```
response = client.count_emails
```

### Get email

Get a single email

```
client.get_email 'EMAIL_ID'
```

### Create email

Create a new certified email.

```
file_path  = '/path/document.pdf'
recipients = [{:name => 'Mr John', :email => 'john.doe@signaturit.com'}]
response  = client.create_email file_path, recipients, 'ruby subject', 'ruby body', {}
```

### Get original file

Get the original document of an email request

```
response = client.download_email_original_file 'EMAIL_ID','CERTIFICATE_ID'
```

### Get audit trail document

Get the audit trail document of an email request

```
response = client.download_email_audit_trail 'EMAIL_ID','CERTIFICATE_ID'
```
