import crypto from "crypto";
import { razorpay } from "../razorpay.js";
import { Order } from "../models/orderModel.js";
import { io } from "../index.js";

export const createRazorpayOrder = async (req, res) => {
  try {
    const { amount, userId,items  } = req.body;

    const options = {
      amount: amount * 100,
      currency: "INR",
      receipt: `rcpt_${Date.now()}`,
    };

    const razorpayOrder = await razorpay.orders.create(options);

    const order = await Order.create({
      userId,
      items,
      totalAmount: amount,
      razorpayOrderId: razorpayOrder.id,
      paymentStatus: "pending",
      status: "received",
    });

    if (io) io.to("admins").emit("newOrder", order);

    res.status(200).json({
      success: true,
      orderId: razorpayOrder.id,
      amount: razorpayOrder.amount,
      currency: razorpayOrder.currency,
      dbOrderId: order._id,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: "Order creation failed", error: err.message });
  }
};

export const verifyPayment = async (req, res) => {
  try {
    const { orderId, paymentId, signature, userId, items, totalAmount } = req.body;

    const generatedSignature = crypto.createHmac("sha256", process.env.RAZORPAY_SECRET)
      .update(orderId + "|" + paymentId)
      .digest("hex");

    if (generatedSignature !== signature) {
      return res.status(400).json({ success: false, message: "Payment verification failed" });
    }

    const updated = await Order.findOneAndUpdate(
      { razorpayOrderId: orderId },
      {
        paymentStatus: "paid",
        paymentId,
        updatedAt: Date.now(),
      },
      { new: true }
    );
    if (io) io.to("admins").emit("orderUpdated", updated);

    const userRoom = userId.toString();
    if (io) io.to(userRoom).emit("orderUpdated", updated);

    return res.status(200).json({ success: true, message: "Payment verified", order: updated });
  } catch (error) {
    res.status(500).json({ success: false, message: "Verification error", error });
  }
};
