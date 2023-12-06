import { Router } from "express";
import { getThingsInView } from "../controllers/thing.controller";

const router = Router();

router.get("/inView", getThingsInView);

export default router;
module.exports = router;
