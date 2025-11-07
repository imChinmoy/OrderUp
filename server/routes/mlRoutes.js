import express from "express";
import { getTop10Recommendations } from "../controllers/mlController.js";
import { verifyToken } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.use(verifyToken);
router.post("/recommend", getTop10Recommendations);

export default router;
