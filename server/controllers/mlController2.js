import axios from "axios";

const CHATBOT_MODEL_URL = "https://canteen-chatbot-api.onrender.com/chat";

export const getChatbotResponse = async (req, res) => {
  try {
    const { user_query } = req.body;

    if (!user_query) {
      return res.status(400).json({
        success: false,
        error: "query field is required.",
      });
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
      return res.status(error.response.status).json({
        success: false,
        error:
          error.response.data?.error ||
          error.response.data?.detail ||
          "Error from Chatbot ML model.",
      });
    }

    return res.status(500).json({
      success: false,
      error: "Failed to connect to Chatbot service. Please try again later.",
    });
  }
};
