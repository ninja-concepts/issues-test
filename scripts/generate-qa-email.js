const fs = require('fs');
const https = require('https');

const issueDetails = JSON.parse(process.env.ISSUE_DETAILS);
const prDetails = JSON.parse(process.env.PR_DETAILS);

const prompt = `Generate a professional QA notification email for a development ticket that's ready for testing.

Issue Details:
${JSON.stringify(issueDetails, null, 2)}

Pull Request Details:
${JSON.stringify(prDetails, null, 2)}

Create an email that:
1. Has a clear, actionable subject line
2. Provides context about what was developed
3. Includes testing requirements if available in the issue body
4. Has links to both the issue and merged PR
5. Is professional and helpful for the QA team

Return in format:
SUBJECT: [subject line]
BODY: [email body in HTML format]`;

const data = JSON.stringify({
  model: "gpt-4.1",
  messages: [
    {
      role: "system",
      content:
        "You are a helpful assistant that generates professional QA notification emails. Focus on providing clear context and actionable information for testing.",
    },
    {
      role: "user",
      content: prompt,
    },
  ],
  max_tokens: 800,
  temperature: 0.5,
});

const options = {
  hostname: 'api.openai.com',
  port: 443,
  path: '/v1/chat/completions',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
    'Content-Length': Buffer.byteLength(data),
  },
};

const req = https.request(options, (res) => {
  let responseData = '';

  res.on('data', (chunk) => {
    responseData += chunk;
  });

  res.on('end', () => {
    try {
      const response = JSON.parse(responseData);
      const emailContent = response.choices[0].message.content;

      const subjectMatch = emailContent.match(/SUBJECT:\s*(.*?)(?:\n|$)/);
      const bodyMatch = emailContent.match(/BODY:\s*([\s\S]*?)$/);

      const subject = subjectMatch
        ? subjectMatch[1].trim()
        : `Ready for QA: Issue #${issueDetails.number} - ${issueDetails.title}`;
      const body = bodyMatch ? bodyMatch[1].trim() : emailContent;

      fs.writeFileSync('/tmp/qa_email_subject.txt', subject);
      fs.writeFileSync('/tmp/qa_email_body.html', body);

      console.log('QA email content generated successfully!');
    } catch (error) {
      console.error('Error generating QA email:', error);

      // Fallback email
      const fallbackSubject = `Ready for QA: Issue #${issueDetails.number} - ${issueDetails.title}`;
      const fallbackBody = `
      <h2>Ready for QA Testing</h2>
      <p><strong>Issue #${issueDetails.number}:</strong> <a href="${issueDetails.html_url}">${issueDetails.title}</a></p>
      <p><strong>Merged PR:</strong> <a href="${prDetails.html_url}">#${prDetails.number} - ${prDetails.title}</a></p>
      <p><strong>Developer:</strong> ${prDetails.user}</p>
      <p><strong>Priority:</strong> ${issueDetails.labels.filter((l) => l.startsWith('priority:')).join(', ') || 'Normal'}</p>
      <p>This ticket has been completed and is ready for testing. Please review the issue description and acceptance criteria.</p>
      `;

      fs.writeFileSync('/tmp/qa_email_subject.txt', fallbackSubject);
      fs.writeFileSync('/tmp/qa_email_body.html', fallbackBody);
    }
  });
});

req.on('error', (error) => {
  console.error('Error calling OpenAI API:', error);
  process.exit(1);
});

req.write(data);
req.end();

