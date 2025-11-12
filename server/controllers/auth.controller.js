import jwt from 'jsonwebtoken';
import User from '../models/user.model.js';
import validator from 'validator';
import CustomError from '../utils/customError.js'; // your custom error class
import sendVerificationEmail from "../utils/sendVerificationEmail.js";
import sendResetPasswordEmail from "../utils/sendResetPasswordEmail.js";
import sgMail from "@sendgrid/mail";
import crypto from "crypto";
import dotenv from 'dotenv';
dotenv.config();
sgMail.setApiKey(process.env.SENDGRID_API_KEY);


const generateToken = (user) => {
  const payload = {
    id: user._id,
    email: user.email,
    name: user.name,
    role: user.role,
  };

  return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '30d' });
};

export const registerHandler = async (req, res, next) => {
  try {
    const { email, password, name, role, adminSecret } = req.body;

     if (role === "admin") {
      if (!adminSecret) {
        return res.status(400).json({
          success: false,
          message: "Admin secret key is required to register as admin",
        });
      }

      if (adminSecret !== process.env.ADMIN_SECRET_KEY) {
        return res.status(403).json({
          success: false,
          message: "Invalid admin secret key",
        });
      }
    }

    if (!email || !password || !name) {
      throw new CustomError('Email, password, and name are required.', 400);
    }

    if (!validator.isEmail(email)) {
      throw new CustomError('Invalid email format.', 400);
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      throw new CustomError('User already exists.', 400);
    }

    const newUser = new User({
      email,
      password,
      name,
      role: role || 'student',
    });

    const verificationToken = crypto.randomBytes(32).toString("hex");
    newUser.verificationToken = verificationToken;
    newUser.verificationTokenExpiry = new Date(Date.now() + 24 * 60 * 60 * 1000);// 24 hours

    await newUser.save();
  
    await sendVerificationEmail(newUser.email, verificationToken);

    res.status(201).json({
      message: 'User registered successfully. A Verification Email is sent to your email ID',
      user: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        role: newUser.role,
      },
    });
  } catch (error) {
    next(error); // pass to centralized error handler
  }
};

export const verifyEmailHandler = async (req, res, next) => {
  console.log("verifyEmailHandler called, query token:", req.query.token);
  try {
    const { token } = req.query;

    const user = await User.findOne({
      verificationToken: token,
      verificationTokenExpiry: { $gt: Date.now() },
    });

    if (!user) {
      throw new CustomError("Invalid or expired verification token.", 400);
    }

    user.emailVerified = true;
    user.verificationToken = undefined;
    user.verificationTokenExpiry = undefined;
    await user.save();

    res.status(200).json({ success: true, message: "Email verified successfully." });
  } catch (error) {
    next(error);
  }
};


export const loginHandler = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      throw new CustomError('Email and password are required.', 400);
    }

    if (!validator.isEmail(email)) {
      throw new CustomError('Invalid email format.', 400);
    }

    const user = await User.findOne({ email });
    if (!user) {
      throw new CustomError('Invalid credentials.', 400);
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      throw new CustomError('Invalid credentials.', 400);
    }

    const token = generateToken(user);

    res.status(200).json({
      message: 'Login successful.',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const forgotPasswordHandler = async (req, res, next) => {
  try {
    const { email } = req.body;
    const user = await User.findOne({ email });

    if (!user) {
      throw new CustomError("No user found with this email.", 404);
    }

    const resetToken = crypto.randomBytes(32).toString("hex");
    user.resetPasswordToken = resetToken;
    user.resetPasswordExpiry = Date.now() + 15 * 60 * 1000; // 15 minutes
    await user.save();

    await sendResetPasswordEmail(user.email, resetToken);

    res.status(200).json({
      success: true,
      message: "Password reset link sent to your email.",
    });
  } catch (error) {
    next(error);
  }
};

export const resetPasswordHandler = async (req, res, next) => {
  try {
    const { token } = req.query;
    const { newPassword } = req.body;
    console.log("Token from query:", req.query.token);

    const user = await User.findOne({
      resetPasswordToken: token,
      resetPasswordExpiry: { $gt: Date.now() },
    });

    if (!user) {
      throw new CustomError("Invalid or expired password reset token.", 400);
    }

    user.password = newPassword;
    user.resetPasswordToken = undefined;
    user.resetPasswordExpiry = undefined;

    await user.save();

    res.status(200).json({
      success: true,
      message: "Password reset successful. You can now log in with your new password.",
    });
  } catch (error) {
    next(error);
  }
};
