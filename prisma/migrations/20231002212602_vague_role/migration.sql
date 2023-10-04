/*
  Warnings:

  - You are about to drop the column `c_when` on the `Assignment` table. All the data in the column will be lost.
  - You are about to drop the column `labelTexts` on the `Assignment` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Assignment" DROP COLUMN "c_when",
DROP COLUMN "labelTexts";

-- CreateTable
CREATE TABLE "VagueRole" (
    "id" SERIAL NOT NULL,
    "c_when" TIMESTAMPTZ(0),
    "labelTexts" XML,

    CONSTRAINT "VagueRole_pkey" PRIMARY KEY ("id")
);
