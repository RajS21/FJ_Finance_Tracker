const express = require("express");
const router = express.Router();
const pool = require("../config/db");
const authenticateToken = require("../middleware/auth.middleware");

router.get("/", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {

    const incomeResult = await pool.query(
      `SELECT COALESCE(SUM(amount),0) AS total_income
       FROM transactions
       WHERE user_id=$1 AND type='income'`,
      [userId]
    );

    const expenseResult = await pool.query(
      `SELECT COALESCE(SUM(amount),0) AS total_expense
       FROM transactions
       WHERE user_id=$1 AND type='expense'`,
      [userId]
    );

    const totalIncome = incomeResult.rows[0].total_income;
    const totalExpense = expenseResult.rows[0].total_expense;

    const balance = totalIncome - totalExpense;

    res.json({
      totalIncome,
      totalExpense,
      balance
    });

  } catch (error) {
    res.status(500).json({ error: "Dashboard data fetch failed" });
  }
});

// Category-wise expenses
router.get("/category-report", authenticateToken, async (req, res) => {
  const userId = req.user.userId;

  try {
    const result = await pool.query(
      `
      SELECT 
        c.name AS category,
        COALESCE(SUM(t.amount),0) AS total_spent
      FROM categories c
      LEFT JOIN transactions t
        ON c.id = t.category_id
      WHERE c.user_id = $1
      GROUP BY c.name
      ORDER BY total_spent DESC
      `,
      [userId]
    );

    res.json(result.rows);

  } catch (error) {
    res.status(500).json({ error: "Failed to generate report" });
  }
});

module.exports = router;