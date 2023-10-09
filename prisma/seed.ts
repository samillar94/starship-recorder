import { PrismaClient } from "@prisma/client";

// type Library = {
//   [propName: string]: {
//     [propName: string]: any;
//   };
// };

const prisma = new PrismaClient();

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });

/// FUNCTIONS

async function main() {
  await clearAllData();
  await addFirstData();
}

async function clearAllData() {
  const tablenames = await prisma.$queryRaw<
    Array<{ tablename: string }>
  >`SELECT tablename FROM pg_tables WHERE schemaname='public'`;

  const tables = tablenames
    .map(({ tablename }) => tablename)
    .filter((name) => name !== "_prisma_migrations")
    .map((name) => `"public"."${name}"`)
    .join(", ");

  try {
    await prisma.$executeRawUnsafe(`TRUNCATE TABLE ${tables} CASCADE;`);
  } catch (error) {
    console.log({ error });
  }
}

async function addFirstData() {
  /// UNITS
  let unit_h = await prisma.unit.create({
    data: {
      editorialCode: "h",
      description: "Hoppy-type ring",
      displayOrder: 10,
      displayedInCombo: true,
    },
  });

  let unit_f = await prisma.unit.create({
    data: {
      editorialCode: "f",
      description: "Hoppy fairing-type cylinder ring",
      displayOrder: 9,
      displayedInCombo: true,
    },
  });

  let unit_D = await prisma.unit.create({
    data: {
      editorialCode: "D",
      description: "Dome",
      displayOrder: 2,
      displayedInCombo: false,
    },
  });

  let unit_C = await prisma.unit.create({
    data: {
      editorialCode: "C",
      description: "Cone",
      displayOrder: 1,
      displayedInCombo: false,
    },
  });

  /// PARTS
  let part_AS_5h = await prisma.part.create({
    data: {
      description:
        "Hoppy v1 aft sleeve (becomes v2 lower tank sleeve then vehicle sleeve) - barrel made from 5 Hoppy-style rings",
      editorialCode: "AS",
      partUnits: {
        create: {
          unitId: unit_h.id, // ring
          numerator: 5,
        },
      },
    },
  });

  let part_A_5h = await prisma.part.create({
    data: {
      description: "Hoppy aft dome stack - 5-ring vehicle barrel + aft dome",
      editorialCode: "A",
      partUnits: {
        create: [
          {
            unitId: unit_h.id, // ring
            numerator: 5,
          },
          {
            unitId: unit_D.id, // dome
            numerator: 1,
          },
        ],
      },
    },
  });

  let part_A_5h_or_AS_5h = await prisma.part.create({
    data: {
      description:
        "Hoppy tank barrel - barrel made from 5 Hoppy-style rings - can't tell if the aft dome is installed or not",
      editorialCode: "/",
      abstractions_iw_generic: {
        create: [
          {
            specific_partId: part_AS_5h.id,
          },
          {
            specific_partId: part_A_5h.id,
          },
        ],
      },
    },
  });

  /// FEATURES
  let feature_leg_cutout = await prisma.feature.create({
    data: {
      name: "leg lower strut cutout",
    },
  });

  let feature_leg_lower = await prisma.feature.create({
    data: {
      name: "leg lower strut",
    },
  });

  /// PARTFEATURES
  let partFeature_A_5h_or_AS_5h_leg_cutouts = await prisma.partFeature.create({
    data: {
      partId: part_A_5h_or_AS_5h.id,
      featureId: feature_leg_cutout.id,
      count: 3,
    },
  });

  let partFeature_A_5h_leg_lower_struts = await prisma.partFeature.create({
    data: {
      partId: part_A_5h.id,
      featureId: feature_leg_lower.id,
      count: 3,
    },
  });

  /// ARTICLEVERSIONS
  let articleVersion_H1_v1 = await prisma.articleVersion.create({
    data: {
      editorialSuffix: "v1",
      scheme: {
        create: {
          description:
            "Starhopper's publicity build - the 3-legged 5-ring tank assembly with only the aft dome had the 4-ring nosecone assembly stacked on and destacked from it twice before 50mph winds knocked it over.",
          schemeClass: "SPECIAL",
        },
      },
      article: {
        create: {
          editorialLetter: "S",
          editorialNumber: "0",
          articleNames: {
            create: {
              name: "Starhopper",
              nameProvenance: {
                create: {
                  type: "official published",
                },
              },
              nameForm: {
                create: {
                  type: "long",
                },
              },
            },
          },
        },
      },
    },
  });

  /// CREDITS
  let credit_mary = await prisma.credit.create({
    data: {
      name: "NSF: Mary",
    },
  });

  let credit_spadre = await prisma.credit.create({
    data: {
      name: "South Padre Surf Club: Rachel & Gene",
    },
  });

  /// SOURCETYPES
  let sourcetype_visual_recording = await prisma.sourceType.create({
    data: {
      type: "Visual recording (photos and videos)",
    },
  });

  /// SOURCES
  let source_1 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=46406.msg1888125#msg1888125",
      commentary: "Mary's earliest shot of Hoppy, on 14 Dec 2018",
      restricted: false,
      sourceType: { connect: { id: sourcetype_visual_recording.id } },
      credit: { connect: { id: credit_mary.id } },
    },
  });

  let source_2 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=46406.msg1888643#msg1888643",
      commentary: "Leg cutouts added to Hoppy aft barrel, 16 Dec 2018",
      restricted: false,
      sourceType: { connect: { id: sourcetype_visual_recording.id } },
      credit: { connect: { id: credit_mary.id } },
    },
  });

  let source_3 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=47001.msg1889809#msg1889809",
      commentary: "Leg lower struts added to Hoppy aft barrel, 19 Dec 2018",
      restricted: false,
      sourceType: { connect: { id: sourcetype_visual_recording.id } },
      credit: { connect: { id: credit_mary.id } },
    },
  });

  let source_4 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=47001.msg1890443#msg1890443",
      commentary:
        "Multiple frame-based cylinder/frustrum sections, 20 Dec 2018",
      restricted: false,
      sourceType: { connect: { id: sourcetype_visual_recording.id } },
      credit: { connect: { id: credit_mary.id } },
    },
  });

  let source_5 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=47001.msg1890748#msg1890748",
      commentary:
        "Clearly conical section stack as well as one of the stacks from yesterday, 21 Dec 2018",
      restricted: false,
      sourceType: { connect: { id: sourcetype_visual_recording.id } },
      credit: { connect: { id: credit_mary.id } },
    },
  });

  let source_6 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=47001.msg1890748#msg1890748",
      commentary:
        "Addition of an upper leg strut and a frame ring (possibly a fit check), 21 Dec 2018",
      restricted: false,
      sourceType: { connect: { id: sourcetype_visual_recording.id } },
      credit: { connect: { id: credit_mary.id } },
    },
  });

  let source_7 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=47001.msg1891123#msg1891123",
      commentary:
        "SPadre video and photos showing all upper leg struts added, and the top of a nosecone is in the onion dome, 22 Dec 2018",
      restricted: false,
      sourceType: { connect: { id: sourcetype_visual_recording.id } },
      credit: { connect: { id: credit_spadre.id } },
    },
  });

  /// STANDS
  let stand_1 = await prisma.stand.create({
    data: {
      description:
        "The first stand, the concrete base on which Hoppy was assembled.",
    },
  });

  /// POSITIONS
  let position_hoppyseat = await prisma.position.create({
    data: {
      name: "Hoppyseat",
      validStart: new Date(2018, 11, 14),
    },
  });

  /// VAGUEPOSITIONS
  let vaguePosition_hoppyyard = await prisma.vaguePosition.create({
    data: {
      name: "Hoppy's construction yard",
      validStart: new Date(2018, 11, 14),
    },
  });

  /// THINGS
  let thing_1 = await prisma.thing.create({
    data: {
      summary:
        "The first piece of Starship hardware: Hoppy's 5-ring aft-to-vehicle barrel (aft dome initially untrackable)",
      // thingNames: {
      //   create: [
      //     {}
      //   ]
      // }
    },
  });

  /// VAGUEROLES
  let vagueRole_t1_vr1 = await prisma.vagueRole.create({
    data: {
      thingId: thing_1.id,
      roles: {
        create: [
          {
            articleVersionId: articleVersion_H1_v1.id,
            partId: part_AS_5h.id,
            confidence: 0.5,
            roleSources: {
              create: {
                sourceId: source_1.id,
              },
            },
          },
          {
            articleVersionId: articleVersion_H1_v1.id,
            partId: part_A_5h.id,
            confidence: 0.5,
            roleSources: {
              create: {
                sourceId: source_1.id,
              },
            },
          },
        ],
      },
    },
  });

  let vagueRole_t1_vr2 = await prisma.vagueRole.create({
    data: {
      thingId: thing_1.id,
      roles: {
        create: [
          {
            articleVersionId: articleVersion_H1_v1.id,
            partId: part_A_5h.id,
            confidence: 0.95,
            roleSources: {
              create: {
                sourceId: source_3.id,
              },
            },
          },
        ],
      },
      c_when: new Date(2018, 11, 19),
    },
  });

  /// RECORDS
  let record_1 = await prisma.record.create({
    data: {
      vagueRole: { connect: { id: vagueRole_t1_vr1.id } },
      observed_part: { connect: { id: part_A_5h_or_AS_5h.id } },
      stand: { connect: { id: stand_1.id } },
      position: { connect: { id: position_hoppyseat.id } },
      earliest: new Date(2018, 11, 14, 4), // need timezone
      latest: new Date(2018, 11, 14, 20), // need timezone
      smoothToNext: false,
      live: false,
      note: "The first record of Starship hardware, from Mary's photograph of Hoppy's 5-ring aft barrel",
      recordSources: {
        create: {
          sourceId: source_1.id,
        },
      },
    },
  });

  let record_2 = await prisma.record.create({
    data: {
      vagueRole: { connect: { id: vagueRole_t1_vr1.id } },
      observed_part: { connect: { id: part_A_5h_or_AS_5h.id } },
      stand: { connect: { id: stand_1.id } },
      position: { connect: { id: position_hoppyseat.id } },
      earliest: new Date(2018, 11, 16, 4), // need timezone
      latest: new Date(2018, 11, 16, 20), // need timezone
      smoothToNext: false,
      live: false,
      note: "At least two, possibly three leg cutouts added",
      recordSources: {
        create: {
          sourceId: source_2.id,
        },
      },
      developments: {
        create: {
          type: "ADDED",
          comparedTo_recordId: record_1.id,
          partFeatureId: partFeature_A_5h_or_AS_5h_leg_cutouts.id,
        },
      },
    },
  });
}
