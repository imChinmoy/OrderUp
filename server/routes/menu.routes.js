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

const router = express.Router();

router.post('/items', createMenuItem);
router.get('/items', getAllItems);
router.get('/items/trending', getTrendingItems);
router.get('/items/category/:category', getItemsByCategory);
router.get('/items/:id', getItemById);
router.put('/items/:id', updateMenuItem);    
router.delete('/items/:id', deleteMenuItem);

export default router;
