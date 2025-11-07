import express from "express";
import { getTop10Recommendations } from "../controllers/mlController.js";
import { verifyToken } from "../middlewares/authMiddleware.js";
import { getChatbotResponse } from "../controllers/mlController2.js";

const router = express.Router();

router.use(verifyToken);
router.post("/recommend", getTop10Recommendations);
router.post("/chat", getChatbotResponse);

export default router;
