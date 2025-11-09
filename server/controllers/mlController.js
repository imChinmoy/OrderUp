import axios from "axios";
import CustomError from "../utils/customError.js";

const ML_MODEL_URL = process.env.ML_MODEL_URL;

export const getRecommendations = async (req, res, next) => {
  try {
    const { Category, Group_Size, Rating, Avg_Spend, Delivery_Time } = req.body;

    if (!Category || Group_Size == null || Rating == null || Avg_Spend == null || Delivery_Time == null) {
      throw new CustomError("All fields are required: Category, Group_Size, Rating, Avg_Spend, Delivery_Time", 400);
    }

    const payload = {
      Category,
      Group_Size,
      Rating,
      Avg_Spend,
      Delivery_Time
    };

    const response = await axios.post(ML_MODEL_URL, payload, {
      headers: { "Content-Type": "application/json" },
      timeout: 1000 * 60 * 2
    });

    return res.status(200).json({
      success: true,
      recommendations: response.data,
    });

  } catch (error) {
    console.error("ML model error:", error.message);

    if (error.response) {
      return next(new CustomError(error.response.data.error || "ML service error", error.response.status));
    }

    return next(new CustomError("Failed to connect to ML service", 502));
  }
};
