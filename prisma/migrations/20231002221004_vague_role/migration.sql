/*
  Warnings:

  - You are about to drop the `Assignment` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `AssignmentSource` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "Assignment" DROP CONSTRAINT "Assignment_articleVersionId_fkey";

-- DropForeignKey
ALTER TABLE "Assignment" DROP CONSTRAINT "Assignment_partId_fkey";

-- DropForeignKey
ALTER TABLE "Assignment" DROP CONSTRAINT "Assignment_vagueRoleId_fkey";

-- DropForeignKey
ALTER TABLE "AssignmentSource" DROP CONSTRAINT "AssignmentSource_assignmentId_fkey";

-- DropForeignKey
ALTER TABLE "AssignmentSource" DROP CONSTRAINT "AssignmentSource_sourceId_fkey";

-- DropTable
DROP TABLE "Assignment";

-- DropTable
DROP TABLE "AssignmentSource";

-- CreateTable
CREATE TABLE "Role" (
    "id" SERIAL NOT NULL,
    "confidence" DECIMAL(3,2) NOT NULL,
    "vagueRoleId" INTEGER NOT NULL,
    "articleVersionId" INTEGER,
    "partId" INTEGER,

    CONSTRAINT "Role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RoleSource" (
    "id" SERIAL NOT NULL,
    "sourceId" INTEGER NOT NULL,
    "roleId" INTEGER NOT NULL,

    CONSTRAINT "RoleSource_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Role" ADD CONSTRAINT "Role_vagueRoleId_fkey" FOREIGN KEY ("vagueRoleId") REFERENCES "VagueRole"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Role" ADD CONSTRAINT "Role_articleVersionId_fkey" FOREIGN KEY ("articleVersionId") REFERENCES "ArticleVersion"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Role" ADD CONSTRAINT "Role_partId_fkey" FOREIGN KEY ("partId") REFERENCES "Part"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RoleSource" ADD CONSTRAINT "RoleSource_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES "Source"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RoleSource" ADD CONSTRAINT "RoleSource_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
