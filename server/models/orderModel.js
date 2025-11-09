import mongoose from "mongoose";

const itemSchema = new mongoose.Schema(
  {
    itemId: { type: String, required: true },
    name: String,
    quantity: { type: Number, required: true },
    price: { type: Number, required: true },
    imageUrl: String,
    notes: String,
  },
  { _id: false }
);

const orderSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  items: [itemSchema],
  totalAmount: { type: Number, required: true },
  
  razorpayOrderId: { type: String },
  paymentId: { type: String },

  status: {
    type: String,
    enum: ["received", "preparing", "ready", "delivered", "cancelled"],
    default: "received",
  },
  paymentStatus: {
    type: String,
    enum: ["pending", "paid", "failed"],
    default: "pending",
  },

  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now },
});

orderSchema.pre("save", function (next) {
  this.updatedAt = Date.now();
  next();
});

export const Order = mongoose.model("Order", orderSchema);
