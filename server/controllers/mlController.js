import axios from "axios";

const ML_MODEL_URL = "https://recommend-1-ex3f.onrender.com/predict_top10";

export const getTop10Recommendations = async (req, res) => {
  try {
    const inputData = req.body;

    const response = await axios.post(ML_MODEL_URL, inputData, {
      headers: { "Content-Type": "application/json" },
      timeout: 60000, // 10 sec timeout to avoid backend hang
    });

    return res.status(200).json({
      success: true,
      recommendations: response.data,
    });
  } catch (error) {
    console.error("ML model error:", error.message);

    if (error.response) {
      return res.status(error.response.status).json({
        success: false,
        error: error.response.data?.error || "Error from ML model.",
      });
    }

    return res.status(500).json({
      success: false,
      error: "Failed to connect to ML service. Please try again later.",
    });
  }
};
