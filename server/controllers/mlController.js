import axios from "axios";
import CustomError from "../utils/customError.js";
import { MenuItem } from "../models/menuItem.model.js";

const ML_MODEL_URL = process.env.ML_MODEL_URL;

export const getRecommendations = async (req, res, next) => {
  try {
    const mlResponse = await axios.post(
      ML_MODEL_URL,
      {
        "Category": req.body.Category,
        "Group_Size": req.body.Group_Size,
        "Rating": req.body.Rating,
        "Avg_Spend": req.body.Avg_Spend,
        "Delivery_Time": req.body.Delivery_Time,
      },
      {
        headers: { "Content-Type": "application/json" },
        timeout: 30000,
      }
    );

    const data = mlResponse.data;

    if (!data || !data.Top_Items || !Array.isArray(data.Top_Items)) {
      throw new CustomError("Invalid ML response format", 500);
    }

    const results = [];

    for (const item of data.Top_Items) {
      const name = item.Item_Name;

      const dbItem = await MenuItem.findOne({
        name: { $regex: new RegExp(`^${name}$`, "i") }
      });

      if (dbItem) {
        results.push({
          id: dbItem.id,
          name: dbItem.name,
          description: dbItem.description,
          price: dbItem.price,
          imageUrl: dbItem.imageUrl,
          category: dbItem.category,
          rating: dbItem.rating,
          deliveryTime: dbItem.deliveryTime,
          probability: item.prob ?? 0,
          source: "database"
        });
      } else {
        results.push({
          id: null,
          name: item.Item_Name,
          description: "No description available",
          price: null,
          imageUrl: "",
          category: req.body.Category ?? "",
          rating: null,
          deliveryTime: null,
          probability: item.prob ?? 0,
          source: "ML-only"
        });
      }
    }

    return res.status(200).json({
      success: true,
      recommendations: results,
    });

  } catch (error) {
    console.log("ML model error:", error.message);

    if (error.response) {
      return next(
        new CustomError(
          error.response.data?.detail || "ML request failed",
          error.response.status
        )
      );
    }

    return next(new CustomError("Failed to connect to ML service", 500));
  }
};











