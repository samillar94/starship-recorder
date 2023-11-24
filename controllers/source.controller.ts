import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";
const sourceClient = new PrismaClient().source;

// getAllSources
export const getAllSources = async (req: Request, res: Response) => {
  try {
    const allSources = await sourceClient.findMany();
    res.status(200).json({
      success: true,
      data: allSources,
    });
  } catch (error) {
    console.log(error);
    res.json({
      success: false,
      message: error,
    });
  }
};
