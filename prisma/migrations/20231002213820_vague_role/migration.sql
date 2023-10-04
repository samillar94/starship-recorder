/*
  Warnings:

  - You are about to drop the column `assignmentId` on the `Record` table. All the data in the column will be lost.
  - You are about to drop the column `endOn_assignmentId` on the `Record` table. All the data in the column will be lost.
  - You are about to drop the column `newPart_assignmentId` on the `Record` table. All the data in the column will be lost.
  - You are about to drop the column `startOn_assignmentId` on the `Record` table. All the data in the column will be lost.
  - Added the required column `vagueRoleId` to the `Record` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Record" DROP CONSTRAINT "Record_assignmentId_fkey";

-- DropForeignKey
ALTER TABLE "Record" DROP CONSTRAINT "Record_endOn_assignmentId_fkey";

-- DropForeignKey
ALTER TABLE "Record" DROP CONSTRAINT "Record_newPart_assignmentId_fkey";

-- DropForeignKey
ALTER TABLE "Record" DROP CONSTRAINT "Record_startOn_assignmentId_fkey";

-- AlterTable
ALTER TABLE "Record" DROP COLUMN "assignmentId",
DROP COLUMN "endOn_assignmentId",
DROP COLUMN "newPart_assignmentId",
DROP COLUMN "startOn_assignmentId",
ADD COLUMN     "endOn_vagueRoleId" INTEGER,
ADD COLUMN     "newPart_vagueRoleId" INTEGER,
ADD COLUMN     "startOn_vagueRoleId" INTEGER,
ADD COLUMN     "vagueRoleId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_vagueRoleId_fkey" FOREIGN KEY ("vagueRoleId") REFERENCES "VagueRole"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_startOn_vagueRoleId_fkey" FOREIGN KEY ("startOn_vagueRoleId") REFERENCES "VagueRole"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_endOn_vagueRoleId_fkey" FOREIGN KEY ("endOn_vagueRoleId") REFERENCES "VagueRole"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_newPart_vagueRoleId_fkey" FOREIGN KEY ("newPart_vagueRoleId") REFERENCES "VagueRole"("id") ON DELETE SET NULL ON UPDATE CASCADE;
