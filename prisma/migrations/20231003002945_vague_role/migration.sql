/*
  Warnings:

  - You are about to drop the column `newPart_vagueRoleId` on the `Record` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Record" DROP CONSTRAINT "Record_newPart_vagueRoleId_fkey";

-- AlterTable
ALTER TABLE "Record" DROP COLUMN "newPart_vagueRoleId",
ADD COLUMN     "resulting_vagueRoleId" INTEGER;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_resulting_vagueRoleId_fkey" FOREIGN KEY ("resulting_vagueRoleId") REFERENCES "VagueRole"("id") ON DELETE SET NULL ON UPDATE CASCADE;
