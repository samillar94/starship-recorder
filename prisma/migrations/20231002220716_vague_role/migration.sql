/*
  Warnings:

  - You are about to drop the column `thingId` on the `Assignment` table. All the data in the column will be lost.
  - Added the required column `vagueRoleId` to the `Assignment` table without a default value. This is not possible if the table is not empty.
  - Added the required column `thingId` to the `VagueRole` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Assignment" DROP CONSTRAINT "Assignment_thingId_fkey";

-- AlterTable
ALTER TABLE "Assignment" DROP COLUMN "thingId",
ADD COLUMN     "vagueRoleId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "VagueRole" ADD COLUMN     "thingId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "VagueRole" ADD CONSTRAINT "VagueRole_thingId_fkey" FOREIGN KEY ("thingId") REFERENCES "Thing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assignment" ADD CONSTRAINT "Assignment_vagueRoleId_fkey" FOREIGN KEY ("vagueRoleId") REFERENCES "VagueRole"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
