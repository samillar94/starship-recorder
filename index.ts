import express, { Application, Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const app: Application = express();
const prisma = new PrismaClient();
const port: number = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

/// ROUTES

app.get("/", (_req: Request, res: Response) => {
  res.send(`Server is running on port: ${port}`);
});

app.get("/api/articles", async (_rep: Request, res: Response) => {
  try {
    const allArticles = await prisma.article.findMany();
    return res.json({
        success: true,
        data: allArticles
    });
  } catch (error) {
      return res.json({
          success: false,
          message: error
      });
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});


