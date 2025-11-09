import express from "express";
import {
  createOrder,
  getAllOrders,
  getOrdersByUser,
  updateOrderStatus,
  deleteOrder
} from "../controllers/orderController.js";
import { verifyToken, adminOnly } from "../middlewares/authMiddleware.js";
const router = express.Router();

router.use(verifyToken);

router.post("/", createOrder); // Student
router.get("/", adminOnly, getAllOrders); // Admin
router.get("/user/:userId", getOrdersByUser); // Student
router.patch("/status/:id", adminOnly, updateOrderStatus); // Admin
router.delete("/:id", deleteOrder); // Student

export default router;
