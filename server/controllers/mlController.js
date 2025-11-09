import axios from "axios";
import CustomError from "../utils/customError.js";

const ML_MODEL_URL = "https://recommend-88ef.onrender.com/predict";

export const getTop10Recommendations = async (req, res, next) => {
  try {
    const { Category, Group_Size, Rating, Avg_Spend, Delivery_Time } = req.body;

    if (!Category) {
      throw new CustomError("Category is required", 400);
    }
    
    const response = await axios.post(
      ML_MODEL_URL,
      {  Category, Group_Size, Rating, Avg_Spend, Delivery_Time},
      {
        headers: { "Content-Type": "application/json" },
        timeout: 10*60000, // 10 minutes timeout
      }
    );

    return res.status(200).json({
      success: true,
      recommendations: response.data,
    });
  } catch (error) {
    console.error("ML model error:", error.message);

    if (error.response) {
      const statusCode = error.response.status || 500;
      const message =
        error.response.data?.error ||
        error.response.data?.detail ||
        "Error from ML model.";
      return next(new CustomError(message, statusCode));
    }

    if (error.code === "ECONNABORTED") {
      return next(new CustomError("ML service timed out. Please try again later.", 504));
    }

    return next(
      new CustomError(
        "Failed to connect to ML service. Please try again later.",
        500
      )
    );
  }
};
