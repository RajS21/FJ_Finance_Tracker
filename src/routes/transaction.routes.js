const express = require("express");
const router = express.Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/auth.middleware");
const upload = require("../middleware/upload.middleware");

router.post(
  "/:id/receipt",
  authenticateToken,
  upload.single("receipt"),
  async (req, res) => {

    res.json({
      message: "Receipt uploaded",
      file: req.file.filename
    });
  }
);

// Add transaction
router.post("/", authenticateToken, async (req, res) => {
  const { category_id, amount, type, description } = req.body;
  const userId = req.user.userId;

  try {
    const result = await pool.query(
      `INSERT INTO transactions 
       (user_id, category_id, amount, type, description)
       VALUES ($1,$2,$3,$4,$5)
       RETURNING *`,
      [userId, category_id, amount, type, description]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    res.status(500).json({ error: "Failed to add transaction" });
  }
});

// Get transactions
router.get("/", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {
    const result = await pool.query(
      `SELECT t.*, c.name as category_name
       FROM transactions t
       LEFT JOIN categories c ON t.category_id = c.id
       WHERE t.user_id = $1
       ORDER BY transaction_date DESC`,
      [userId]
    );

    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: "Failed to fetch transactions" });
  }
});

// Delete transaction
router.delete("/:id", authenticateToken, async (req, res) => {

  const userId = req.user.userId;
  const transactionId = req.params.id;

  try {

    const result = await pool.query(
      `DELETE FROM transactions 
       WHERE id=$1 AND user_id=$2
       RETURNING *`,
      [transactionId, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    res.json({
      message: "Transaction deleted successfully",
      transaction: result.rows[0]
    });

  } catch (error) {
    res.status(500).json({ error: "Failed to delete transaction" });
  }

});

//Update transaction
router.put("/:id", authenticateToken, async (req, res) => {
  const userId = req.user.userId;
  const transactionId = req.params.id;

  const { category_id, amount, type, description } = req.body;

  try {
    const result = await pool.query(
      `UPDATE transactions 
       SET category_id=$1, amount=$2, type=$3, description=$4
       WHERE id=$5 AND user_id=$6
       RETURNING *`,
      [category_id, amount, type, description, transactionId, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Transaction not found" });
    }

    res.json({
      message: "Transaction updated successfully",
      transaction: result.rows[0],
    });

  } catch (error) {
    res.status(500).json({ error: "Failed to update transaction" });
  }
});

module.exports = router;