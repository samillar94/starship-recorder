import express, { Application, Request, Response } from "express";
import { PrismaClient } from "@prisma/client";

const app: Application = express();
const prisma = new PrismaClient();
const port: number = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

addFirstData()
.then(async () => {
  await prisma.$disconnect();
})
.catch(async (e) => {
  console.error(e);
  await prisma.$disconnect();
  process.exit(1);
});


/// ROUTES

app.get("/", (_req: Request, res: Response) => {
  res.send(`Server is running on port: ${port}`);
});

app.get("/api/articles", async (_rep: Request, res: Response) => {
  try {
    const allArticles = await prisma.article.findMany();
    return res.json({
        success: true,
        data: allArticles
    });
  } catch (error) {
      return res.json({
          success: false,
          message: error
      });
  }
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
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
              colorClass: {
                create: {
                  name: "ship",
                  description: "Color for S-series vehicles",
                  colorTheme: "blue"
                }
              }
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