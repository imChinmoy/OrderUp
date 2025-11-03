import express from 'express';
import dotenv from 'dotenv';
dotenv.config();


import authRouter from './routes/auth.route.js';
import connectDB from './db.js';

const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json());

app.use('/api/auth', authRouter);
// app.use('/api/meals', mealsRouter);

app.listen(PORT,'0.0.0.0', () => {
    connectDB();
    console.log(`✅ Server is running on port ${PORT}`);
});