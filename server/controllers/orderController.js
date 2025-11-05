import { Order } from "../models/orderModel.js";
import { MenuItem } from "../models/menuItem.model.js";
import { io } from "../index.js";

export const createOrder = async (req, res) => {
  try {
    const { userId, items, totalAmount } = req.body;

    for (const item of items) {
      const menuItem = await MenuItem.findById(item.itemId);
      if (!menuItem) {
        return res.status(400).json({ message: `Invalid item: ${item.name}` });
      }
    }

    const order = await Order.create({ userId, items, totalAmount });
    if (io) io.to("admins").emit("newOrder", order);
    res.status(201).json(order);
  } catch (error) {
    res.status(500).json({ message: "Error creating order", error: error.message });
  }
};

export const getAllOrders = async (req, res) => {
  try {
    const orders = await Order.find().populate("userId", "name");
    res.status(200).json(orders);
  } catch (error) {
    res.status(500).json({ message: "Error fetching orders", error: error.message });
  }
};

export const getOrdersByUser = async (req, res) => {
  try {
    const { userId } = req.params;
    const orders = await Order.find({ userId });
    res.status(200).json(orders);
  } catch (error) {
    res.status(500).json({ message: "Error fetching user orders", error: error.message });
  }
};

export const updateOrderStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const order = await Order.findByIdAndUpdate(
      id,
      { status, updatedAt: Date.now() },
      { new: true }
    );

    if (!order) return res.status(404).json({ message: "Order not found" });
    const orderUserId = order.userId._id ? order.userId._id.toString() : order.userId.toString();
    if (io) io.to(orderUserId).emit("orderUpdated", order);
    res.status(200).json(order);
  } catch (error) {
    res.status(500).json({ message: "Error updating status", error: error.message });
  }
};

//  Delete (Cancel) an order - Student
export const deleteOrder = async (req, res) => {
  try {
    const { id } = req.params; // orderId
    const { userId } = req.body; 

    const order = await Order.findById(id);
    if (!order) {
      return res.status(404).json({ message: "Order not found" });
    }

    if (order.userId.toString() !== userId) {
      return res.status(403).json({ message: "Unauthorized to delete this order" });
    }

    if (order.paymentStatus !== "pending" || order.status !== "received") {
      return res.status(400).json({
        message: "Order cannot be deleted once payment is completed or preparation has started",
      });
    }

    await Order.findByIdAndDelete(id);

    //  Notify admin (optional, for real-time updates)
    if(io) io.to('admins').emit('orderCancelled', { orderId: id, userId });

    res.status(200).json({ message: "Order deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: "Error deleting order", error: error.message });
  }
};

