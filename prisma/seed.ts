import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

addFirstData()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });

/// FUNCTIONS

async function addFirstData() {
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

  // await addFirstHoppyRecord();
}

async function addFirstHoppyRecord() {
  let unit_h = await prisma.unit.create({
    data: {
      editorialCode: "h",
      description: "Hoppy-type ring",
      displayOrder: 10,
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

  let part_TS_5h = await prisma.part.create({
    data: {
      description: "Hoppy tank barrel - barrel made from 5 Hoppy-style rings",
      editorialCode: "TS",
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
      description: "Hoppy aft dome stack - tank barrel + aft dome",
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

  // let part_A_5h_or_TS_5h = await prisma.part.create({
  //   data: {
  //     description:
  //       "Hoppy tank barrel - barrel made from 5 Hoppy-style rings - can't tell if the aft dome is installed or not",
  //     editorialCode: "/",
  //     abstractions_iw_generic: {
  //       create: [
  //         {
  //           specific_partId: part_TS_5h.id,
  //         },
  //         {
  //           specific_partId: part_A_5h.id,
  //         },
  //       ],
  //     },
  //   },
  // });

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
      // assignments: {
      //   create: {
      //     thing: {
      //       create: {},
      //     },
      //     confidence: 1,
      //     // partId: part_A_5h_or_TS_5h.id, /// no idea why this won't accept existing IDs
      //     part: {
      //       create: {
      //         description:
      //           "Hoppy tank barrel - barrel made from 5 Hoppy-style rings - can't tell if the aft dome is installed or not",
      //         editorialCode: "/",
      //         abstractions_iw_generic: {
      //           create: [
      //             {
      //               specific_partId: part_TS_5h.id,
      //             },
      //             {
      //               specific_partId: part_A_5h.id,
      //             },
      //           ],
      //         },
      //       },
      //     },
      //   },
      // },
    },
  });

  // let source_1 = prisma.source.create({
  //   data: {
  //     mediaURI:
  //       "https://forum.nasaspaceflight.com/index.php?topic=46406.msg1888125#msg1888125",
  //     commentary: "Mary's earliest shot of Hoppy, on 14 Dec 2018",
  //     restricted: false,
  //   },
  // });
}
