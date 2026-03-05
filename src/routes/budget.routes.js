const express = require("express");
const router = express.Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/auth.middleware");

router.post("/", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  const { category_id, limit_amount } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO budgets (user_id, category_id, limit_amount)
       VALUES ($1,$2,$3)
       RETURNING *`,
      [userId, category_id, limit_amount]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to create budget" });
  }
});

module.exports = router;