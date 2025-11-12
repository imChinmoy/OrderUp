import sgMail from "@sendgrid/mail";
import dotenv from "dotenv";
dotenv.config();

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

const sendResetPasswordEmail = async (email, token) => {
  const resetUrl = `https://orderup-3xkw.onrender.com//api/auth/reset-password?token=${token}`;

  const msg = {
    to: email,
    from: process.env.SENDGRID_SENDER_EMAIL,
    subject: "Password Reset Request - OrderUp",
    html: `
      <div style="font-family: Arial, sans-serif;">
        <h2>Password Reset Request</h2>
        <p>We received a request to reset your password for your OrderUp account.</p>
        <p>Click the link below to reset your password (valid for 15 minutes):</p>
        <a href="${resetUrl}" 
           style="background: #007bff; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px;">
           Reset Password
        </a>
        <p>If you didn’t request this, please ignore this email.</p>
      </div>
    `,
  };

  await sgMail.send(msg);
};

export default sendResetPasswordEmail;
