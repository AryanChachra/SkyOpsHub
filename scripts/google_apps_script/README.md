# Demo Request Webhook Setup

This Google Apps Script saves each demo request as a text file in:
`1vKMO3Ak8uu3GG8RRWDe_IoNUYyMOKyX-`

It also emails:
`aryanchachra1406@gmail.com`

## Steps

1. Open `https://script.google.com/`.
2. Create a new Apps Script project.
3. Replace the default file contents with `demo_request_webhook.gs`.
4. Deploy it as a Web App:
   - Execute as: `Me`
   - Who has access: `Anyone`
5. Copy the deployed Web App URL.
6. Paste that URL into `RedesignConfig.demoRequestWebhookUrl`.

After that, the website form will submit directly to the script.
