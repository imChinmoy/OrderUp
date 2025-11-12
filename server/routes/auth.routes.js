import express from 'express';
import { loginHandler , verifyEmailHandler, registerHandler, forgotPasswordHandler, resetPasswordHandler } from '../controllers/auth.controller.js';

const router = express.Router();

router.post('/register', registerHandler);
router.get("/verify-email", verifyEmailHandler);
router.post('/login', loginHandler);
router.post("/forgot-password", forgotPasswordHandler);
router.get("/reset-password", async (req, res, next) => {
  try {
    const { token } = req.query;
    const user = await User.findOne({
      resetPasswordToken: token,
      resetPasswordExpiry: { $gt: Date.now() },
    });
    if (!user) {
      throw new CustomError("Invalid or expired token.", 400);
    }

    res.status(200).json({ success: true, message: "Valid token. You may now reset your password." });
  } catch (error) {
    next(error);
  }
});

router.post("/reset-password", resetPasswordHandler);


export default router;