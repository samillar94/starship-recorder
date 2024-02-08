import { Router } from "express";
import {
  getThingsInView,
  getThingSummary,
} from "../controllers/thing.controller";

const router = Router();

router.get("/inView", getThingsInView);
router.get("/summary", getThingSummary);

export default router;
module.exports = router;
