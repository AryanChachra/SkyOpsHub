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
6. Paste that URL into the `WEBHOOK` constant at the top of `assets/js/form.js`.

After that, the early-access form (on the home page and at /form/) submits directly to the script. The site sends `name`, `workEmail`, `companyName` and `message`; the selected team is prefixed to `message`, so the script needs no changes.
