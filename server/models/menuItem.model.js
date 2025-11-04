import mongoose from 'mongoose';

const menuItemSchema = new mongoose.Schema({
  id: { type: String, required: true, unique: true },
  name: { type: String, required: true },
  description: String,
  price: { type: Number, required: true },
  imageUrl: String,
  isTrending: { type: Boolean, default: false },
  isAvailable: { type: Boolean, default: true },
  category: String,
},{ collection: 'items' });

export const MenuItem = mongoose.model('MenuItem', menuItemSchema);
