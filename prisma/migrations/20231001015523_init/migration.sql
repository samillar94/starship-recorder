-- CreateEnum
CREATE TYPE "DevelopmentType" AS ENUM ('SAME', 'ADDED', 'ADDED_MORE', 'ADDED_ALL_EXPECTED', 'REMOVED_SOME', 'REMOVED_ALL');

-- CreateTable
CREATE TABLE "SourceType" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "SourceType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Credit" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "logoURI" TEXT,

    CONSTRAINT "Credit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NameProvenance" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "NameProvenance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NameForm" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "NameForm_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Article" (
    "id" SERIAL NOT NULL,
    "editorialLetter" TEXT NOT NULL,
    "editorialNumber" TEXT NOT NULL,

    CONSTRAINT "Article_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Stand" (
    "id" SERIAL NOT NULL,
    "description" TEXT,
    "rhinoAssetId" TEXT,
    "groundElevationM" DOUBLE PRECISION,

    CONSTRAINT "Stand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ColourClass" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "colorTheme" TEXT,

    CONSTRAINT "ColourClass_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Unit" (
    "id" SERIAL NOT NULL,
    "editorialCode" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "displayOrder" TEXT NOT NULL,
    "displayedInCombo" BOOLEAN NOT NULL,

    CONSTRAINT "Unit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mirocard" (
    "id" SERIAL NOT NULL,
    "miroId" INTEGER NOT NULL,
    "title" XML NOT NULL,
    "description" XML NOT NULL,
    "x" DECIMAL(30,15) NOT NULL,
    "y" DECIMAL(30,15) NOT NULL,
    "backgroundColor" TEXT NOT NULL,
    "createdAt" TIMESTAMPTZ(0) NOT NULL,
    "createdByName" TEXT NOT NULL,
    "modifiedAt" TIMESTAMPTZ(0) NOT NULL,
    "modifiedByName" TEXT NOT NULL,

    CONSTRAINT "Mirocard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Thing" (
    "id" SERIAL NOT NULL,
    "summary" TEXT,

    CONSTRAINT "Thing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EventType" (
    "id" SERIAL NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "EventType_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Feature" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Feature_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Source" (
    "id" SERIAL NOT NULL,
    "mediaURI" TEXT NOT NULL,
    "commentary" TEXT,
    "sourceTypeId" INTEGER NOT NULL,
    "creditId" INTEGER NOT NULL,

    CONSTRAINT "Source_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ArticleName" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "articleId" INTEGER NOT NULL,
    "nameProvenanceId" INTEGER NOT NULL,
    "nameFormId" INTEGER NOT NULL,

    CONSTRAINT "ArticleName_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scheme" (
    "id" SERIAL NOT NULL,
    "description" TEXT NOT NULL,
    "diagramAsset2dURI" TEXT NOT NULL,
    "diagramAsset3dURI" TEXT NOT NULL,
    "colourClassId" INTEGER NOT NULL,

    CONSTRAINT "Scheme_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ArticleMirocard" (
    "id" SERIAL NOT NULL,
    "articleId" INTEGER NOT NULL,
    "mirocardId" INTEGER NOT NULL,

    CONSTRAINT "ArticleMirocard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ThingMirocard" (
    "id" SERIAL NOT NULL,
    "thingId" INTEGER NOT NULL,
    "mirocardId" INTEGER NOT NULL,

    CONSTRAINT "ThingMirocard_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ArticleNameSource" (
    "id" SERIAL NOT NULL,
    "sourceId" INTEGER NOT NULL,
    "articleNameId" INTEGER NOT NULL,

    CONSTRAINT "ArticleNameSource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ArticleVersion" (
    "id" SERIAL NOT NULL,
    "editorialSuffix" TEXT NOT NULL DEFAULT '',
    "diagramAsset3dURI" TEXT,
    "articleId" INTEGER NOT NULL,
    "schemeId" INTEGER,

    CONSTRAINT "ArticleVersion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SameThing" (
    "id" SERIAL NOT NULL,
    "confidence" DECIMAL(3,2) NOT NULL,
    "thingId1" INTEGER NOT NULL,
    "thingId2" INTEGER NOT NULL,

    CONSTRAINT "SameThing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Part" (
    "id" SERIAL NOT NULL,
    "description" TEXT NOT NULL,
    "editorialCode" TEXT,
    "rhinoAssetId" TEXT,
    "markerAsset2dURI" TEXT,
    "diagramAsset2dURI" TEXT,
    "diagramAsset3dURI" TEXT,
    "schemeId" INTEGER,

    CONSTRAINT "Part_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Position" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "r" INTEGER DEFAULT 0,
    "validStart" DATE NOT NULL,
    "validEnd" DATE NOT NULL,

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VaguePosition" (
    "id" SERIAL NOT NULL,
    "name" TEXT,
    "validStart" DATE NOT NULL,
    "validEnd" DATE NOT NULL,

    CONSTRAINT "VaguePosition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Assignment" (
    "id" SERIAL NOT NULL,
    "confidence" DECIMAL(3,2) NOT NULL,
    "labelTexts" XML,
    "c_when" TIMESTAMPTZ(0) NOT NULL,
    "thingId" INTEGER NOT NULL,
    "articleVersionId" INTEGER,
    "partId" INTEGER,

    CONSTRAINT "Assignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartName" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "partId" INTEGER NOT NULL,
    "nameProvenanceId" INTEGER NOT NULL,
    "nameFormId" INTEGER NOT NULL,

    CONSTRAINT "PartName_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartFeature" (
    "id" SERIAL NOT NULL,
    "count" INTEGER,
    "partId" INTEGER,
    "featureId" INTEGER,

    CONSTRAINT "PartFeature_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PartUnit" (
    "id" SERIAL NOT NULL,
    "numerator" INTEGER NOT NULL,
    "denominator" INTEGER NOT NULL DEFAULT 1,
    "partId" INTEGER NOT NULL,
    "unitId" INTEGER NOT NULL,

    CONSTRAINT "PartUnit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Mate" (
    "id" SERIAL NOT NULL,
    "static_partId" INTEGER NOT NULL,
    "added_partId" INTEGER NOT NULL,
    "new_partId" INTEGER,

    CONSTRAINT "Mate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Abstraction" (
    "id" SERIAL NOT NULL,
    "generic_partId" INTEGER NOT NULL,
    "specific_partId" INTEGER NOT NULL,

    CONSTRAINT "Abstraction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AssignmentSource" (
    "id" SERIAL NOT NULL,
    "sourceId" INTEGER NOT NULL,
    "assignmentId" INTEGER NOT NULL,

    CONSTRAINT "AssignmentSource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Record" (
    "id" SERIAL NOT NULL,
    "when" TIMESTAMPTZ(0) NOT NULL,
    "earliest" TIMESTAMPTZ(0) NOT NULL,
    "latest" TIMESTAMPTZ(0) NOT NULL,
    "smoothToNext" BOOLEAN NOT NULL,
    "live" BOOLEAN NOT NULL,
    "note" TEXT,
    "assignmentId" INTEGER NOT NULL,
    "startOn_assignmentId" INTEGER,
    "endOn_assignmentId" INTEGER,
    "newPart_assignmentId" INTEGER,
    "observed_partId" INTEGER,
    "standId" INTEGER,
    "positionId" INTEGER NOT NULL,

    CONSTRAINT "Record_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RecordSource" (
    "id" SERIAL NOT NULL,
    "sourceId" INTEGER NOT NULL,
    "recordId" INTEGER NOT NULL,

    CONSTRAINT "RecordSource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Event" (
    "id" SERIAL NOT NULL,
    "eventTypeId" INTEGER NOT NULL,
    "recordId" INTEGER NOT NULL,

    CONSTRAINT "Event_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Development" (
    "id" SERIAL NOT NULL,
    "type" "DevelopmentType" NOT NULL,
    "featureId" INTEGER NOT NULL,
    "recordId" INTEGER NOT NULL,
    "comparedTo_recordId" INTEGER NOT NULL,

    CONSTRAINT "Development_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RecordVaguePosition" (
    "id" SERIAL NOT NULL,
    "confidence" DECIMAL(3,2) NOT NULL,
    "negative" BOOLEAN NOT NULL,
    "recordId" INTEGER NOT NULL,
    "vaguePositionId" INTEGER NOT NULL,

    CONSTRAINT "RecordVaguePosition_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "SourceType_type_key" ON "SourceType"("type");

-- CreateIndex
CREATE UNIQUE INDEX "Credit_name_key" ON "Credit"("name");

-- CreateIndex
CREATE UNIQUE INDEX "NameProvenance_type_key" ON "NameProvenance"("type");

-- CreateIndex
CREATE UNIQUE INDEX "NameForm_type_key" ON "NameForm"("type");

-- CreateIndex
CREATE UNIQUE INDEX "Article_editorialLetter_editorialNumber_key" ON "Article"("editorialLetter", "editorialNumber");

-- CreateIndex
CREATE UNIQUE INDEX "Unit_editorialCode_key" ON "Unit"("editorialCode");

-- CreateIndex
CREATE UNIQUE INDEX "Unit_description_key" ON "Unit"("description");

-- CreateIndex
CREATE UNIQUE INDEX "Unit_displayOrder_key" ON "Unit"("displayOrder");

-- CreateIndex
CREATE UNIQUE INDEX "Mirocard_miroId_key" ON "Mirocard"("miroId");

-- CreateIndex
CREATE UNIQUE INDEX "Feature_name_key" ON "Feature"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Scheme_description_key" ON "Scheme"("description");

-- CreateIndex
CREATE UNIQUE INDEX "ArticleVersion_editorialSuffix_articleId_key" ON "ArticleVersion"("editorialSuffix", "articleId");

-- CreateIndex
CREATE UNIQUE INDEX "Part_description_key" ON "Part"("description");

-- CreateIndex
CREATE UNIQUE INDEX "PartUnit_partId_unitId_key" ON "PartUnit"("partId", "unitId");

-- AddForeignKey
ALTER TABLE "Source" ADD CONSTRAINT "Source_sourceTypeId_fkey" FOREIGN KEY ("sourceTypeId") REFERENCES "SourceType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Source" ADD CONSTRAINT "Source_creditId_fkey" FOREIGN KEY ("creditId") REFERENCES "Credit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleName" ADD CONSTRAINT "ArticleName_articleId_fkey" FOREIGN KEY ("articleId") REFERENCES "Article"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleName" ADD CONSTRAINT "ArticleName_nameProvenanceId_fkey" FOREIGN KEY ("nameProvenanceId") REFERENCES "NameProvenance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleName" ADD CONSTRAINT "ArticleName_nameFormId_fkey" FOREIGN KEY ("nameFormId") REFERENCES "NameForm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheme" ADD CONSTRAINT "Scheme_colourClassId_fkey" FOREIGN KEY ("colourClassId") REFERENCES "ColourClass"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleMirocard" ADD CONSTRAINT "ArticleMirocard_articleId_fkey" FOREIGN KEY ("articleId") REFERENCES "Article"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleMirocard" ADD CONSTRAINT "ArticleMirocard_mirocardId_fkey" FOREIGN KEY ("mirocardId") REFERENCES "Mirocard"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThingMirocard" ADD CONSTRAINT "ThingMirocard_thingId_fkey" FOREIGN KEY ("thingId") REFERENCES "Thing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThingMirocard" ADD CONSTRAINT "ThingMirocard_mirocardId_fkey" FOREIGN KEY ("mirocardId") REFERENCES "Mirocard"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleNameSource" ADD CONSTRAINT "ArticleNameSource_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES "Source"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleNameSource" ADD CONSTRAINT "ArticleNameSource_articleNameId_fkey" FOREIGN KEY ("articleNameId") REFERENCES "ArticleName"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleVersion" ADD CONSTRAINT "ArticleVersion_articleId_fkey" FOREIGN KEY ("articleId") REFERENCES "Article"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ArticleVersion" ADD CONSTRAINT "ArticleVersion_schemeId_fkey" FOREIGN KEY ("schemeId") REFERENCES "Scheme"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SameThing" ADD CONSTRAINT "SameThing_thingId1_fkey" FOREIGN KEY ("thingId1") REFERENCES "Thing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SameThing" ADD CONSTRAINT "SameThing_thingId2_fkey" FOREIGN KEY ("thingId2") REFERENCES "Thing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Part" ADD CONSTRAINT "Part_schemeId_fkey" FOREIGN KEY ("schemeId") REFERENCES "Scheme"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assignment" ADD CONSTRAINT "Assignment_thingId_fkey" FOREIGN KEY ("thingId") REFERENCES "Thing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assignment" ADD CONSTRAINT "Assignment_articleVersionId_fkey" FOREIGN KEY ("articleVersionId") REFERENCES "ArticleVersion"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assignment" ADD CONSTRAINT "Assignment_partId_fkey" FOREIGN KEY ("partId") REFERENCES "Part"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartName" ADD CONSTRAINT "PartName_partId_fkey" FOREIGN KEY ("partId") REFERENCES "Part"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartName" ADD CONSTRAINT "PartName_nameProvenanceId_fkey" FOREIGN KEY ("nameProvenanceId") REFERENCES "NameProvenance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartName" ADD CONSTRAINT "PartName_nameFormId_fkey" FOREIGN KEY ("nameFormId") REFERENCES "NameForm"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartFeature" ADD CONSTRAINT "PartFeature_partId_fkey" FOREIGN KEY ("partId") REFERENCES "Part"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartFeature" ADD CONSTRAINT "PartFeature_featureId_fkey" FOREIGN KEY ("featureId") REFERENCES "Feature"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartUnit" ADD CONSTRAINT "PartUnit_partId_fkey" FOREIGN KEY ("partId") REFERENCES "Part"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PartUnit" ADD CONSTRAINT "PartUnit_unitId_fkey" FOREIGN KEY ("unitId") REFERENCES "Unit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mate" ADD CONSTRAINT "Mate_static_partId_fkey" FOREIGN KEY ("static_partId") REFERENCES "Part"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mate" ADD CONSTRAINT "Mate_added_partId_fkey" FOREIGN KEY ("added_partId") REFERENCES "Part"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Mate" ADD CONSTRAINT "Mate_new_partId_fkey" FOREIGN KEY ("new_partId") REFERENCES "Part"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Abstraction" ADD CONSTRAINT "Abstraction_generic_partId_fkey" FOREIGN KEY ("generic_partId") REFERENCES "Part"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Abstraction" ADD CONSTRAINT "Abstraction_specific_partId_fkey" FOREIGN KEY ("specific_partId") REFERENCES "Part"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentSource" ADD CONSTRAINT "AssignmentSource_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES "Source"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AssignmentSource" ADD CONSTRAINT "AssignmentSource_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES "Assignment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES "Assignment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_startOn_assignmentId_fkey" FOREIGN KEY ("startOn_assignmentId") REFERENCES "Assignment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_endOn_assignmentId_fkey" FOREIGN KEY ("endOn_assignmentId") REFERENCES "Assignment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_newPart_assignmentId_fkey" FOREIGN KEY ("newPart_assignmentId") REFERENCES "Assignment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_observed_partId_fkey" FOREIGN KEY ("observed_partId") REFERENCES "Part"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_standId_fkey" FOREIGN KEY ("standId") REFERENCES "Stand"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Record" ADD CONSTRAINT "Record_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecordSource" ADD CONSTRAINT "RecordSource_sourceId_fkey" FOREIGN KEY ("sourceId") REFERENCES "Source"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecordSource" ADD CONSTRAINT "RecordSource_recordId_fkey" FOREIGN KEY ("recordId") REFERENCES "Record"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_eventTypeId_fkey" FOREIGN KEY ("eventTypeId") REFERENCES "EventType"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Event" ADD CONSTRAINT "Event_recordId_fkey" FOREIGN KEY ("recordId") REFERENCES "Record"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Development" ADD CONSTRAINT "Development_featureId_fkey" FOREIGN KEY ("featureId") REFERENCES "Feature"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Development" ADD CONSTRAINT "Development_recordId_fkey" FOREIGN KEY ("recordId") REFERENCES "Record"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Development" ADD CONSTRAINT "Development_comparedTo_recordId_fkey" FOREIGN KEY ("comparedTo_recordId") REFERENCES "Record"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecordVaguePosition" ADD CONSTRAINT "RecordVaguePosition_recordId_fkey" FOREIGN KEY ("recordId") REFERENCES "Record"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecordVaguePosition" ADD CONSTRAINT "RecordVaguePosition_vaguePositionId_fkey" FOREIGN KEY ("vaguePositionId") REFERENCES "VaguePosition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
