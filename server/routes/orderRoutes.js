import express from "express";
import {
  createOrder,
  getAllOrders,
  getOrdersByUser,
  updateOrderStatus,
  deleteOrder
} from "../controllers/orderController.js";

const router = express.Router();

router.post("/", createOrder); // Student
router.get("/", getAllOrders); // Admin
router.get("/user/:userId", getOrdersByUser); // Student
router.patch("/status/:id", updateOrderStatus); // Admin
router.delete("/:id", deleteOrder); // Student


export default router;
