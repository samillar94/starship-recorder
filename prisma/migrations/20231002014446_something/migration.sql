/*
  Warnings:

  - Changed the type of `displayOrder` on the `Unit` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- AlterTable
ALTER TABLE "Unit" DROP COLUMN "displayOrder",
ADD COLUMN     "displayOrder" INTEGER NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "Unit_displayOrder_key" ON "Unit"("displayOrder");
