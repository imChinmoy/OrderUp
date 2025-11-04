import { MenuItem } from '../models/menuItem.model.js';


export async function getAllItems(req, res) {
  try {
    const items = await MenuItem.find();
    res.status(200).json(items);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch items' });
  } 
}


export async function getItemById(req, res) {
  const { id } = req.params;
  try {
    const item = await MenuItem.findOne({ id });
    if (!item) {
      return res.status(404).json({ error: 'Item not found' });
    }
    res.status(200).json(item);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch item' });
  }
}


export async function getTrendingItems(req, res) {
  try {
    const trendingItems = await MenuItem.find({ isTrending: true });
    res.status(200).json(trendingItems);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch trending items' });
  }
}

export async function getItemsByCategory(req, res) {
  const { category } = req.params;
  try {
    const items = await MenuItem.find({ category });
    res.status(200).json(items);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch items by category' });
  }
}
