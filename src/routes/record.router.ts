import { Router } from "express";
import { getAllRecords } from "../controllers/record.controller";

const router = Router();

router.get("/all", getAllRecords);

export default router;
module.exports = router;
