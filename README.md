Signaturit Ruby SDK
===================

This package is a wrapper for Signaturit Api. If you didn't read the documentation yet, maybe it's time to take a look [here](http://docs.signaturit.com/).

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
response = client.get_signatures()
```

##### Getting the last 50 signatures

```
response = client.get_signatures(50)
```

##### Getting the following last 50 signatures

```
response = client.get_signatures(50, 50)
```

##### Getting only the finished signatures 

```
response = client.get_signatures(100, 0, 3)
```

##### Getting the finished signatures created since July 20th of 2014

```
response = client.get_signatures(100, 0, 3, '2014-7-20')
```

### Count signature requests

Count your signature requests.

```
response = client.count_signatures()
```

### Get signature request

Get a single signature request.

```
response = client.get_signature('SIGNATURE_ID')
```

### Get signature documents

Get all documents from a signature request.

```
response = client.get_signature_documents('SIGNATURE_ID')
```

### Get signature document

Get a single document from a signature request.

```
response = client.get_signature_document('SIGNATURE_ID','DOCUMENT_ID')
```

### Signature request

Create a new signature request. Check all [params](http://docs.signaturit.com/api/#sign_create_sign).

```
recipients =  ['bobsoap@signatur.it']
params = {:subject: 'Receipt number 250', :body: 'Please, can you sign this document?'}
file_path = '/documents/contracts/125932_important.pdf'
response = client.create_signature_request(file_path, recipients, params)
```

### Get audit trail

Get the audit trail of a signature request document and save it in the submitted path.

```
response = client.get_audit_trail('ID', 'DOCUMENT_ID', '/path/doc.pdf')
```

### Get signed document

Get the signed document of a signature request document and save it in the submitted path.

```
response = client.get_signed_document('ID', 'DOCUMENT_ID', '/path/doc.pdf')
```

## Account

### Get account

Retrieve the information of your account.

```
response = client.get_account()
```

### Set document storage

Set your own storage credentials, to store a copy of the documents. You can get all the info of credential types [here](http://docs.signaturit.com/api/#account_set_credentials).

```
credentials = {
    :user: 'john',
    :port: 22,
    :dir: '/test',
    :host: 'john.doe.server',
    :password: 'XXX',
    :auth_method: 'PASS'
}
response = client.set_document_storage('sftp', credentials)
```

### Revert to default document storage

If you ever want to store your files in Signaturit's servers just run this method:

```
client.revert_to_default_document_storage()
```

## Branding

### Get brandings

Get all account brandings.

```
response = client.get_brandings()
```

### Get branding

Get a single branding.

```
response = client.get_branding('BRANDING_ID')
```

### Create branding

Create a new branding. You can check all branding params [here](http://docs.signaturit.com/api/#set_branding).`

```
params = {
    :corporate_layout_color: '#FFBF00',
    :corporate_text_color: '#2A1B0A',
    :application_texts: { :sign_button: 'Sign!' }
}
response = client.create_branding(params)
```

### Update branding

Update a single branding.

```
params = { :application_texts: { :send_button: 'Send!' } }
response = client.update_branding('BRANDING_ID', params)
```

### Update branding logo

Change the branding logo.

```
file_path = '/path/new_logo.png'
response = client.update_branding_logo('BRANDING_ID', file_path)
```

### Update branding template

Change a template. Learn more about the templates [here](http://docs.signaturit.com/api/#put_template_branding).

```
file_path = '/path/new_template.html'
response = client.update_branding_template('BRANDING_ID', 'sign_request', file_path)
```

## Template

### Get all templates

Retrieve all data from your templates.

```
response = client.get_templates()
```
