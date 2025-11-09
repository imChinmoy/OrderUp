import express from 'express';
import { loginHandler , verifyEmailHandler, registerHandler } from '../controllers/auth.controller.js';

const router = express.Router();

router.post('/register', registerHandler);
router.get("/verify-email", verifyEmailHandler);
router.post('/login', loginHandler);

export default router;