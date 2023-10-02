/*
  Warnings:

  - You are about to drop the column `featureId` on the `Development` table. All the data in the column will be lost.
  - You are about to drop the column `colorClassId` on the `Scheme` table. All the data in the column will be lost.
  - You are about to drop the `ColorClass` table. If the table is not empty, all the data it contains will be lost.
  - Added the required column `partFeatureId` to the `Development` table without a default value. This is not possible if the table is not empty.
  - Added the required column `schemeClass` to the `Scheme` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "SchemeClass" AS ENUM ('SHIP', 'STACK', 'SUPERHEAVY', 'SPECIAL', 'SERVICE', 'SOMETHING');

-- DropForeignKey
ALTER TABLE "Development" DROP CONSTRAINT "Development_featureId_fkey";

-- DropForeignKey
ALTER TABLE "Scheme" DROP CONSTRAINT "Scheme_colorClassId_fkey";

-- AlterTable
ALTER TABLE "Development" DROP COLUMN "featureId",
ADD COLUMN     "partFeatureId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Scheme" DROP COLUMN "colorClassId",
ADD COLUMN     "schemeClass" "SchemeClass" NOT NULL;

-- DropTable
DROP TABLE "ColorClass";

-- CreateTable
CREATE TABLE "ThingName" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "thingId" INTEGER NOT NULL,
    "nameProvenanceId" INTEGER NOT NULL,
    "nameFormId" INTEGER NOT NULL,

    CONSTRAINT "ThingName_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SchemePart" (
    "id" SERIAL NOT NULL,
    "schemeId" INTEGER,
    "partId" INTEGER,

    CONSTRAINT "SchemePart_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "ThingName" ADD CONSTRAINT "ThingName_thingId_fkey" FOREIGN KEY ("thingId") REFERENCES "Part"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThingName" ADD CONSTRAINT "ThingName_nameProvenanceId_fkey" FOREIGN KEY ("nameProvenanceId") REFERENCES "NameProvenance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThingName" ADD CONSTRAINT "ThingName_nameFormId_fkey" FOREIGN KEY ("nameFormId") REFERENCES "NameForm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SchemePart" ADD CONSTRAINT "SchemePart_schemeId_fkey" FOREIGN KEY ("schemeId") REFERENCES "Scheme"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SchemePart" ADD CONSTRAINT "SchemePart_partId_fkey" FOREIGN KEY ("partId") REFERENCES "Part"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Development" ADD CONSTRAINT "Development_partFeatureId_fkey" FOREIGN KEY ("partFeatureId") REFERENCES "PartFeature"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
