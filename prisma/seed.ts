import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

var library: any;

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

async function addFirstData() {
  await addFirstLibraryData();
  await addFirstHoppyData();
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

async function addFirstLibraryData() {
  library.unit_h = await prisma.unit.create({
    data: {
      editorialCode: "h",
      description: "Hoppy-type ring",
      displayOrder: 10,
      displayedInCombo: true,
    },
  });

  library.unit_D = await prisma.unit.create({
    data: {
      editorialCode: "D",
      description: "Dome",
      displayOrder: 2,
      displayedInCombo: false,
    },
  });

  library.unit_C = await prisma.unit.create({
    data: {
      editorialCode: "C",
      description: "Cone",
      displayOrder: 1,
      displayedInCombo: false,
    },
  });

  library.part_AS_5h = await prisma.part.create({
    data: {
      description:
        "Hoppy v1 aft sleeve (becomes v2 lower tank sleeve then vehicle sleeve) - barrel made from 5 Hoppy-style rings",
      editorialCode: "AS",
      partUnits: {
        create: {
          unitId: library.unit_h.id, // ring
          numerator: 5,
        },
      },
    },
  });

  library.part_A_5h = await prisma.part.create({
    data: {
      description: "Hoppy aft dome stack - 5-ring vehicle barrel + aft dome",
      editorialCode: "A",
      partUnits: {
        create: [
          {
            unitId: library.unit_h.id, // ring
            numerator: 5,
          },
          {
            unitId: library.unit_D.id, // dome
            numerator: 1,
          },
        ],
      },
    },
  });

  library.part_A_5h_or_AS_5h = await prisma.part.create({
    data: {
      description:
        "Hoppy tank barrel - barrel made from 5 Hoppy-style rings - can't tell if the aft dome is installed or not",
      editorialCode: "/",
      abstractions_iw_generic: {
        create: [
          {
            specific_partId: library.part_AS_5h.id,
          },
          {
            specific_partId: library.part_A_5h.id,
          },
        ],
      },
    },
  });
}

async function addFirstHoppyData() {
  let articleVersion_S0_v1 = await prisma.articleVersion.create({
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

  let source_1 = await prisma.source.create({
    data: {
      mediaURI:
        "https://forum.nasaspaceflight.com/index.php?topic=46406.msg1888125#msg1888125",
      commentary: "Mary's earliest shot of Hoppy, on 14 Dec 2018",
      restricted: false,
      sourceType: {
        create: {
          type: "Photo",
        },
      },
      credit: {
        create: {
          name: "NSF Mary",
        },
      },
    },
  });

  let record_1 = await prisma.record.create({
    data: {
      vagueRole: {
        create: {
          thing: {
            create: {
              summary:
                "The first piece of Starship hardware: Hoppy's 5-ring aft-to-vehicle barrel (aft dome untrackable)",
              // thingNames: {
              //   create: [
              //     {}
              //   ]
              // }
            },
          },
          roles: {
            create: [
              {
                articleVersionId: articleVersion_S0_v1.id,
                partId: library.part_AS_5h.id,
                confidence: 0.5,
                roleSources: {
                  create: {
                    sourceId: source_1.id,
                  },
                },
              },
              {
                articleVersionId: articleVersion_S0_v1.id,
                partId: library.part_A_5h.id,
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
      },
      observed_part: {
        connect: { id: library.part_A_5h_or_AS_5h.id },
      },
      stand: {
        create: {
          description:
            "The first stand, the concrete base on which Hoppy was assembled.",
        },
      },
      position: {
        create: {
          name: "Hoppyseat",
          validStart: new Date(2018, 11, 14),
        },
      },
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
}
