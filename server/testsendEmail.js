import sgMail from "@sendgrid/mail";
import dotenv from "dotenv";
dotenv.config();

// Set your SendGrid API key
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

async function sendTestEmail() {
  try {
    const msg = {
      to: "your_email@example.com", // replace with your personal email
      from: {
        email: process.env.SENDGRID_SENDER_EMAIL, // must match verified sender
        name: "OrderUp"
      },
      subject: "Test Email from OrderUp",
      text: "Hello! This is a test email from your Node app.",
      html: "<p>Hello! This is a <strong>test email</strong> from your Node app.</p>"
    };

    const response = await sgMail.send(msg);
    console.log("Email sent successfully!", response[0].statusCode);
  } catch (error) {
    console.error("Error sending email:", error);
  }
}

sendTestEmail();
