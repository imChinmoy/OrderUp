import express from 'express';
import {
  getAllItems,
  getItemById,
  getTrendingItems,
  getItemsByCategory,
  createMenuItem,
  updateMenuItem,
  deleteMenuItem
} from '../controllers/menuController.js';
import { verifyToken, adminOnly } from "../middlewares/authMiddleware.js";

const router = express.Router();

router.use(verifyToken);

router.post('/items', adminOnly,  createMenuItem);
router.get('/items', getAllItems);
router.get('/items/trending', getTrendingItems);
router.get('/items/category/:category', getItemsByCategory);
router.get('/items/:id', getItemById);
router.put('/items/:id', adminOnly, updateMenuItem);    
router.delete('/items/:id', adminOnly, deleteMenuItem);

export default router;
