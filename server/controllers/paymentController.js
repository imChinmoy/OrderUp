import crypto from "crypto";
import { razorpay } from "../razorpay.js";
import { Order } from "../models/orderModel.js";

export const createRazorpayOrder = async (req, res) => {
  try {
    const { amount, userId } = req.body;

    const options = {
      amount: amount * 100,
      currency: "INR",
      receipt: `rcpt_${Date.now()}`,
    };

    const order = await razorpay.orders.create(options);

    res.status(200).json({
      success: true,
      orderId: order.id,
      amount: order.amount,
      currency: order.currency,
      userId,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: "Order creation failed", error: err.message });
  }
};

export const verifyPayment = async (req, res) => {
  try {
    const { orderId, paymentId, signature, userId } = req.body;

    const generatedSignature = crypto.createHmac("sha256", process.env.RAZORPAY_SECRET)
      .update(orderId + "|" + paymentId)
      .digest("hex");

    if (generatedSignature !== signature) {
      return res.status(400).json({ success: false, message: "Payment verification failed" });
    }

    await Order.findOneAndUpdate(
      { razorpayOrderId: orderId },
      { paymentStatus: "paid", paymentId, updatedAt: Date.now() }
    );

    return res.status(200).json({ success: true, message: "Payment verified" });
  } catch (error) {
    res.status(500).json({ success: false, message: "Verification error", error });
  }
};
