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

export const createMenuItem = async (req, res) => {
  try {
    const { id, name, description, price, imageUrl, category, isTrending, isAvailable } = req.body;

    const existingItem = await MenuItem.findOne({ id });
    if (existingItem) {
      return res.status(400).json({ message: 'Item with this ID already exists' });
    }

    const newItem = new MenuItem({
      id,
      name,
      description,
      price,
      imageUrl,
      category,
      isTrending,
      isAvailable
    }); 
    const savedItem = await newItem.save();
    res.status(201).json(savedItem);
  } catch (error) {
    res.status(500).json({ message: 'Error creating menu item', error: error.message });
  }
};

export const updateMenuItem = async (req, res) => {
  try {
    const { id } = req.params;
    const updates = req.body;

    const updatedItem = await MenuItem.findOneAndUpdate({ id }, updates, { new: true });

    if (!updatedItem) {
      return res.status(404).json({ message: 'Menu item not found' });
    }

    res.status(200).json(updatedItem);
  } catch (error) {
    res.status(500).json({ message: 'Error updating menu item', error: error.message });
  }
};

export const deleteMenuItem = async (req, res) => {
  try {
    const { id } = req.params;
    const deletedItem = await MenuItem.findOneAndDelete({ id });

    if (!deletedItem) {
      return res.status(404).json({ message: 'Menu item not found' });
    }

    res.status(200).json({ message: 'Menu item deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting menu item', error: error.message });
  }
};