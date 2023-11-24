import { Router } from "express";
const router = Router();

router.get("/", (req, res) => {
  res.json({
    message: `Server is running. Available routes:
    \nrecord/all
    \nsource/all`,
  });
});

router.post("/", (req, res) => {
  res.json({
    message: `Server is running. Available routes to be included here.`,
  });
});

export default router;
