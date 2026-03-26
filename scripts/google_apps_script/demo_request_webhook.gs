const FOLDER_ID = '1vKMO3Ak8uu3GG8RRWDe_IoNUYyMOKyX-';
const NOTIFICATION_EMAIL = 'aryanchachra1406@gmail.com';

function doPost(e) {
  try {
    const name = sanitize_(e.parameter.name || 'Unknown');
    const workEmail = sanitize_(e.parameter.workEmail || '');
    const companyName = sanitize_(e.parameter.companyName || '');
    const message = sanitize_(e.parameter.message || '');

    if (!name || !workEmail || !companyName) {
      return jsonResponse_(200, {
        ok: false,
        message: 'Missing required fields.',
      });
    }

    const folder = DriveApp.getFolderById(FOLDER_ID);
    const timestamp = Utilities.formatDate(
      new Date(),
      Session.getScriptTimeZone(),
      'yyyy-MM-dd_HH-mm-ss'
    );
    const fileName = `${name}_${timestamp}.txt`;
    const fileBody = [
      `Name: ${name}`,
      `Work Email: ${workEmail}`,
      `Company / Airline Name: ${companyName}`,
      `Message: ${message || 'N/A'}`,
      `Submitted At: ${new Date().toISOString()}`,
    ].join('\n');

    folder.createFile(fileName, fileBody, MimeType.PLAIN_TEXT);

    MailApp.sendEmail({
      to: NOTIFICATION_EMAIL,
      subject: `New demo request from ${name}`,
      body: [
        'A new demo request has been submitted.',
        '',
        `Name: ${name}`,
        `Work Email: ${workEmail}`,
        `Company / Airline Name: ${companyName}`,
        `Message: ${message || 'N/A'}`,
      ].join('\n'),
    });

    return jsonResponse_(200, {ok: true});
  } catch (error) {
    return jsonResponse_(200, {
      ok: false,
      message: error && error.message ? error.message : 'Unknown error.',
    });
  }
}

function jsonResponse_(status, payload) {
  return ContentService.createTextOutput(JSON.stringify(payload)).setMimeType(
    ContentService.MimeType.JSON
  );
}

function sanitize_(value) {
  return String(value).trim();
}
