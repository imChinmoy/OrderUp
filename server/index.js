import { Server } from "socket.io";
import http from "http";
import express from 'express';
import dotenv from 'dotenv';
dotenv.config();
import authRouter from './routes/auth.routes.js';
import menuRoutes from './routes/menu.routes.js';
import connectDB from './db.js';
import orderRoutes from "./routes/orderRoutes.js";
import paymentRoutes from "./routes/payment.routes.js";
import mlRoutes from "./routes/mlRoutes.js";

const app = express();
const PORT = process.env.PORT || 8080;
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*", // not needed for our app
  },
});

io.on("connection", (socket) => {
  console.log("⚡ New client connected:", socket.id);
   console.log("Handshake query:", socket.handshake);  
  socket.on("join", (role, userId) => {
    if (role === "admin") socket.join("admins");
    else if (role === "student") socket.join(userId);
  });

  socket.on("disconnect", () => {
    
    console.log("Client disconnected:", socket.id);
  });
});
export { io, server };

app.use(express.json());

app.use('/api/auth', authRouter);
app.use('/api', menuRoutes);
app.use("/api/orders", orderRoutes);
app.use("/api/payment", paymentRoutes);
app.use("/api/ml", mlRoutes); 

server.listen(PORT,'0.0.0.0', () => {
    connectDB();
    console.log(`✅ Server is running on port ${PORT}`);
});