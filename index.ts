import express, { Application, Request, Response } from "express";
const cors = require("cors");
import { PrismaClient } from "@prisma/client";
import fs from "fs";

const app: Application = express();
const prisma = new PrismaClient();
const port: number = 3000;

app.use(
  cors({
    origin: "http://localhost:1234",
    methods: "GET,HEAD,PUT,PATCH,POST,DELETE",
  })
);

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/// route handler
const routeFiles = fs
  .readdirSync("./src/routes")
  .filter((file) => file.endsWith(".ts") && !file.startsWith("_"));
for (const file of routeFiles) {
  const route = require(`./src/routes/${file}`);
  app.use(`/${file.slice(0, -10)}`, route);
}
import testRoute from "./src/routes/_test.router";
app.use(`/`, testRoute);

/// up
app.listen(port, () => {
  console.log(`Server is running on at http://localhost:${port}`);
});
