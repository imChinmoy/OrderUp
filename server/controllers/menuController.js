import { MenuItem } from '../models/menuItem.model.js';
import CustomError from '../utils/customError.js';

export async function getAllItems(req, res, next) {
  try {
    const items = await MenuItem.find();
    res.status(200).json(items);
  } catch (err) {
    return next(new CustomError('Failed to fetch items', 500));
  }
}

export async function getItemById(req, res, next) {
  const { id } = req.params;
  try {
    const item = await MenuItem.findOne({ id });
    if (!item) {
      throw new CustomError('Item not found', 404);
    }
    res.status(200).json(item);
  } catch (err) {
    if (err instanceof CustomError) return next(err);
    return next(new CustomError('Failed to fetch item', 500));
  }
}

export async function getTrendingItems(req, res, next) {
  try {
    const trendingItems = await MenuItem.find({ isTrending: true });
    res.status(200).json(trendingItems);
  } catch (err) {
    return next(new CustomError('Failed to fetch trending items', 500));
  }
}
export async function getAvailableItems(req, res, next) {
  try {
    const getAvailableItems = await MenuItem.find({ isAvailable: true });
    res.status(200).json(getAvailableItems);
  } catch (err) {
    return next(new CustomError('Failed to fetch trending items', 500));
  }
}

export async function getItemsByCategory(req, res, next) {
  const { category } = req.params;
  try {
    const items = await MenuItem.find({ category });
    res.status(200).json(items);
  } catch (err) {
    return next(new CustomError('Failed to fetch items by category', 500));
  }
}

export const createMenuItem = async (req, res, next) => {
  try {
    const { id, name, description, price, imageUrl, category, isTrending, isAvailable } = req.body;

    const existingItem = await MenuItem.findOne({ id });
    if (existingItem) {
      throw new CustomError('Item with this ID already exists', 400);
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
    if (error instanceof CustomError) return next(error);
    return next(new CustomError('Error creating menu item', 500));
  }
};

export const updateMenuItem = async (req, res, next) => {
  try {
    const { id } = req.params;
    const updates = req.body;

    const updatedItem = await MenuItem.findOneAndUpdate({ id }, updates, { new: true });

    if (!updatedItem) {
      throw new CustomError('Menu item not found', 404);
    }

    res.status(200).json(updatedItem);
  } catch (error) {
    if (error instanceof CustomError) return next(error);
    return next(new CustomError('Error updating menu item', 500));
  }
};

export const deleteMenuItem = async (req, res, next) => {
  try {
    const { id } = req.params;
    const deletedItem = await MenuItem.findOneAndDelete({ id });

    if (!deletedItem) {
      throw new CustomError('Menu item not found', 404);
    }

    res.status(200).json({ message: 'Menu item deleted successfully' });
  } catch (error) {
    if (error instanceof CustomError) return next(error);
    return next(new CustomError('Error deleting menu item', 500));
  }
};
