import express, { Application, Request, Response } from "express";
import { PrismaClient } from "@prisma/client";
import fs from "fs";

const app: Application = express();
const prisma = new PrismaClient();
const port: number = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/// route handler
const routeFiles = fs
  .readdirSync("./routes")
  .filter((file) => file.endsWith(".ts") && !file.startsWith("_"));
for (const file of routeFiles) {
  const route = require(`./routes/${file}`);
  app.use(`/${file.slice(0, -10)}`, route);
}
import testRoute from "./routes/_test.router";
app.use(`/`, testRoute);

/// ROUTES

app.get("/records", async (_rep: Request, res: Response) => {
  try {
    const allRecords = await prisma.record.findMany();
    return res.json({
      success: true,
      data: allRecords,
    });
  } catch (error) {
    return res.json({
      success: false,
      message: error,
    });
  }
});

app.listen(port, () => {
  console.log(`Server is running on at http://localhost:${port}`);
});
