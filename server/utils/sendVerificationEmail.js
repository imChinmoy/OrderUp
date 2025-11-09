import dotenv from "dotenv";
dotenv.config();
import sgMail from "@sendgrid/mail";
sgMail.setApiKey(process.env.SENDGRID_API_KEY);

const sendVerificationEmail = async (userEmail, token) => {
  const verificationUrl = `https://orderup-3xkw.onrender.com/api/auth/verify-email?token=${token}`;
  const msg = {
    to: userEmail,
    from: {
        email:process.env.SENDGRID_SENDER_EMAIL,
    name: "OrderUp"
},
    subject: "Verify your email",
    html: `
      <p>Welcome! Please verify your email by clicking the link below:</p>
      <a href="${verificationUrl}">Verify Email</a>
      <p>This link expires in 24 hours.</p>
    `,
  };

  await sgMail.send(msg);
};

export default sendVerificationEmail;
