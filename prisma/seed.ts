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

  await addFirstHoppyRecord()
  
  
}

async function addFirstHoppyRecord() {

  await prisma.article.create({
    data: {
      editorialLetter: "S",
      editorialNumber: "0",
      articleNames: {
        create: {
          name: "Starhopper",
          nameProvenance: {
            create: {
              type: "official published"
            }
          },
          nameForm: {
            create: {
              type: "long"
            }
          }
        }
      },
      articleVersions: {
        create: {
          editorialSuffix: "v1",
          scheme: {
            create: {
              description: "Starhopper's publicity build - the 3-legged 5-ring tank assembly with only the aft dome had the 4-ring nosecone assembly stacked on and destacked from it twice before 50mph winds knocked it over.",
              schemeClass: "SHIP"
            }
          }// ,
          // assignments: {
          //   create: {

          //   }
          // }
        }
      }
    }
  })

  
}