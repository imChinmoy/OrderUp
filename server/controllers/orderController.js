import { Order } from "../models/orderModel.js";
import { MenuItem } from "../models/menuItem.model.js";
import { io } from "../index.js";
import CustomError from "../utils/customError.js";
import User from "../models/user.model.js";

export const createOrder = async (req, res, next) => {
  try {
    const { userId, items, totalAmount } = req.body;
    const detailedItems = [];
    for (const item of items) {
      const menuItem = await MenuItem.findById(item.itemId);
      if (!menuItem) {
        throw new CustomError(`Invalid item: ${item.name}`, 400);
      }
      detailedItems.push({
    itemId: menuItem._id,
    name: menuItem.name,
    quantity: item.quantity || 1,
    price: menuItem.price
  });

    }
    const order = await Order.create({ userId, items: detailedItems, totalAmount });
    
    await User.findByIdAndUpdate(userId, {
    $push: {
      orders: {
        orderId: order._id,
        items: detailedItems,
        totalAmount
      }
    }
  });
    if (io) io.to("admins").emit("newOrder", order);
    res.status(201).json(order);
  } catch (error) {
    next(new CustomError(error.message || "Error creating order", 500));
  }
};

export const getAllOrders = async (req, res, next) => {
  try {
    const orders = await Order.find().populate("userId", "name");
    res.status(200).json(orders);
  } catch (error) {
    next(new CustomError(error.message || "Error fetching orders", 500));
  }
};

export const getOrdersByUser = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const orders = await Order.find({ userId });
    res.status(200).json(orders);
  } catch (error) {
    next(new CustomError(error.message || "Error fetching user orders", 500));
  }
};

export const updateOrderStatus = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const order = await Order.findByIdAndUpdate(
      id,
      { status, updatedAt: Date.now() },
      { new: true }
    );

    if (!order) throw new CustomError("Order not found", 404);
    const orderUserId = order.userId._id ? order.userId._id.toString() : order.userId.toString();
    if (io) io.to(orderUserId).emit("orderUpdated", order);
    res.status(200).json(order);
  } catch (error) {
    next(new CustomError(error.message || "Error updating status", 500));
  }
};

//  Delete (Cancel) an order - Student
export const deleteOrder = async (req, res, next) => {
  try {
    const { id } = req.params; // orderId
    const { userId } = req.body; 

    const order = await Order.findById(id);
    if (!order) {
      throw new CustomError("Order not found", 404);
    }

    if (order.userId.toString() !== userId) {
      throw new CustomError("Unauthorized to delete this order", 403);
    }

    if (order.paymentStatus !== "pending" || order.status !== "received") {
      throw new CustomError(
        "Order cannot be deleted once payment is completed or preparation has started",
        400
      );
    }

    await Order.findByIdAndDelete(id);

    //  Notify admin (optional, for real-time updates)
    if (io) io.to("admins").emit("orderCancelled", { orderId: id, userId });

    res.status(200).json({ message: "Order deleted successfully" });
  } catch (error) {
    next(new CustomError(error.message || "Error deleting order", 500));
  }
};
