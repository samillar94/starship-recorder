/*
  Warnings:

  - You are about to drop the column `colourClassId` on the `Scheme` table. All the data in the column will be lost.
  - You are about to drop the `ColourClass` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `colorClassId` to the `Scheme` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "Scheme" DROP CONSTRAINT "Scheme_colourClassId_fkey";

-- AlterTable
ALTER TABLE "Scheme" DROP COLUMN "colourClassId",
ADD COLUMN     "colorClassId" INTEGER NOT NULL;

-- DropTable
DROP TABLE "ColourClass";

-- CreateTable
CREATE TABLE "ColorClass" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "colorTheme" TEXT,

    CONSTRAINT "ColorClass_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Scheme" ADD CONSTRAINT "Scheme_colorClassId_fkey" FOREIGN KEY ("colorClassId") REFERENCES "ColorClass"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
