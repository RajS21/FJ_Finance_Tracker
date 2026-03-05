const express = require("express");
const router = express.Router();
const pool = require("../config/db");

const authenticateToken = require("../middleware/auth.middleware");

// Create category
router.post("/", authenticateToken, async (req, res) => {
  const { name, type } = req.body;
  const userId = req.user.userId;

  try {
    const result = await pool.query(
      "INSERT INTO categories (user_id, name, type) VALUES ($1,$2,$3) RETURNING *",
      [userId, name, type]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to create category" });
  }
});

// Get categories
router.get("/", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {
    const result = await pool.query(
      "SELECT * FROM categories WHERE user_id = $1",
      [userId]
    );

    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch categories" });
  }
});

module.exports = router;