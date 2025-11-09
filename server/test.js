import crypto from "crypto";

const orderId = "order_RdciMUEESV1jgb"; // replace with actual
const paymentId = "pay_test123";  // fake ID
const secret = "AoGn3UNS5Sn2NCFisJGvh2lH"; // from .env

const signature = crypto
  .createHmac("sha256", secret)
  .update(orderId + "|" + paymentId)
  .digest("hex");

console.log(signature);
