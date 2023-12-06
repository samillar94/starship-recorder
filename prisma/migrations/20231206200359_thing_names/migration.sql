-- DropForeignKey
ALTER TABLE "ThingName" DROP CONSTRAINT "ThingName_thingId_fkey";

-- AddForeignKey
ALTER TABLE "ThingName" ADD CONSTRAINT "ThingName_thingId_fkey" FOREIGN KEY ("thingId") REFERENCES "Thing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
