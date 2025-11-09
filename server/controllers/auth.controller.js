import jwt from 'jsonwebtoken';
import User from '../models/user.model.js';
import validator from 'validator';
import CustomError from '../utils/customError.js'; // your custom error class

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

    await newUser.save();
    const token = generateToken(newUser);

    res.status(201).json({
      message: 'User registered successfully.',
      token,
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
