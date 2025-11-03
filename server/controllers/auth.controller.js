import jwt from 'jsonwebtoken';
import User from '../models/user.model.js';
import validator from 'validator';


const generateToken = (user) => {
  const payload = {
    id: user._id,
    email: user.email,
    name: user.name,
    role: user.role,
  };

  return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '30d' });
};


export const registerHandler = async (req, res) => {
  try {
    const { email, password, name, role } = req.body;

    if (!email || !password || !name) {
      return res
        .status(400)
        .json({ error: 'Email, password, and name are required.' });
    }

    if (!validator.isEmail(email)) {
      return res.status(400).json({ error: 'Invalid email format.' });
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'User already exists.' });
    }

    const newUser = new User({
      email,
      password,
      name,
      role: role || 'student',
    });
    await newUser.save();

    const token = generateToken(newUser);

    return res.status(201).json({
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
    console.error('Error during registration:', error);
    return res.status(500).json({ error: 'Internal server error.' });
  }
};


export const loginHandler = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json({ error: 'Email and password are required.' });
    }

    if (!validator.isEmail(email)) {
      return res.status(400).json({ error: 'Invalid email format.' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: 'Invalid credentials.' });
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Invalid credentials.' });
    }

    const token = generateToken(user);

    return res.status(200).json({
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
    console.error('Error during login:', error);
    return res.status(500).json({ error: 'Internal server error.' });
  }
};
