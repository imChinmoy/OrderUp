import axios from "axios";
import CustomError from "../utils/customError.js";

const CHATBOT_MODEL_URL = "https://canteen-chatbot-api.onrender.com/chat";

export const getChatbotResponse = async (req, res, next) => {
  try {
    const { user_query } = req.body;

    if (!user_query) {
      throw new CustomError("query field is required.", 400);
    }

    const response = await axios.post(
      CHATBOT_MODEL_URL,
      { user_query },
      {
        headers: { "Content-Type": "application/json" },
        timeout: 30000, // 30 seconds timeout
      }
    );

    return res.status(200).json({
      success: true,
      chatbotResponse: response.data,
    });
  } catch (error) {
    console.error("Chatbot model error:", error.message);

    if (error.response) {
      const statusCode = error.response.status || 500;
      const message =
        error.response.data?.error ||
        error.response.data?.detail ||
        "Error from Chatbot ML model.";
      return next(new CustomError(message, statusCode));
    }

    if (error.code === "ECONNABORTED") {
      return next(
        new CustomError("Chatbot service timed out. Please try again later.", 504)
      );
    }

    return next(
      new CustomError(
        "Failed to connect to Chatbot service. Please try again later.",
        500
      )
    );
  }
};
