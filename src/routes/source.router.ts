import { Router } from "express";
import { getAllSources } from "../controllers/source.controller";

const router = Router();

router.get("/all", getAllSources);

export default router;
module.exports = router;
