import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";
const recordClient = new PrismaClient().record;

// getAllRecords
export const getAllRecords = async (req: Request, res: Response) => {
  try {
    const allRecords = await recordClient.findMany();
    res.status(200).json({
      success: true,
      data: allRecords,
    });
  } catch (error) {
    console.log(error);
    res.json({
      success: false,
      message: error,
    });
  }
};
