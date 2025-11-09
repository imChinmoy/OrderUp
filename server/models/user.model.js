import mongoose from 'mongoose';
import bcrypt from 'bcrypt';

const { Schema, model } = mongoose;

const userSchema = new Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required'],
      trim: true,
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
      trim: true,
    },
    password: {
      type: String,
      required: [true, 'Password is required'],
      minlength: [6, 'Password must be at least 6 characters long'],
    },
    role: {
      type: String,
      enum: ['student', 'admin'],
      default: 'student',
      required: true,
    },
    orders: [
      {
        orderId: { type: Schema.Types.ObjectId, ref: 'Orders' },
    items: [
      {
        itemId: { type: Schema.Types.ObjectId, ref: 'MenuItem' },
        name: String,
        quantity: Number,
        price: Number
      }
    ],
    totalAmount: Number
      },
    ],
  emailVerified: {
  type: Boolean,
  default: false
  },
  verificationToken: String,
  verificationTokenExpiry: Date,},
  {
    timestamps: true,
  }
);


userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();

  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (err) {
    next(err);
  }
});


userSchema.methods.comparePassword = function (candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};

export default model('User', userSchema);
