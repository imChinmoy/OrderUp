import express from "express";
import { getRecommendations } from "../controllers/mlController.js";
import { verifyToken } from "../middlewares/authMiddleware.js";
import { getChatbotResponse } from "../controllers/mlController2.js";

const router = express.Router();

router.use(verifyToken);
router.post("/recommend", getRecommendations);
router.post("/chat", getChatbotResponse);

export default router;
