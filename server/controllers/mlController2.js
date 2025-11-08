import axios from "axios";
import CustomError from "../utils/customError.js";

const CHATBOT_MODEL_URL = "https://canteen-chatbot-api.onrender.com/chat";

export const getChatbotResponse = async (req, res, next) => {
  try {
    const { user_query } = req.body;

    if (!user_query) {
      return res.status(400).json({
        success: false,
        error: "user_query is required",
      });
    }

    const response = await axios.post(
      CHATBOT_MODEL_URL,
      { user_query },
      {
        headers: { "Content-Type": "application/json" },
        timeout: 10*60000,  // 10 minutes timeout
      }
    );

    console.log("✅ Raw ML Response:", response.data);

    const botText = response.data?.response || "Sorry, I couldn’t understand that.";

    return res.status(200).json({
      success: true,
      message: botText,
    });

  } catch (error) {
    console.error("❌ Chatbot Error:", error.message);

    return res.status(500).json({
      success: false,
      error: "Chatbot is unavailable. Try again later.",
    });
  }
};
