import express from 'express';
import {
  getAllItems,
  getItemById,
  getTrendingItems,
  getItemsByCategory,
} from '../controllers/menuController.js';

const router = express.Router();

router.get('/items', getAllItems);
router.get('/items/trending', getTrendingItems);
router.get('/items/category/:category', getItemsByCategory);
router.get('/items/:id', getItemById);

export default router;
