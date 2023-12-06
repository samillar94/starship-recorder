import { PrismaClient } from "@prisma/client";
import { Request, Response } from "express";
const thingClient = new PrismaClient().thing;

type ThingInViewData = {
  thingId: number;
  position: [number, number];
  crs: number;
  thingShortName?: string;
  articleShortName?: string;
  articleVersionSuffix?: string;
  partCode?: string | null;
  partAsset?: string | null;
  partUnits?: unknown[];
  schemeClass?: string;
};

//TODO filter by bounding box and time
export const getThingsInView = async (req: Request, res: Response) => {
  try {
    console.log(req);
    const thingsInView = await thingClient.findMany({
      select: {
        id: true,
        thingNames: true, // TODO select best
        vagueRoles: {
          orderBy: { c_when: "desc" }, //TODO use last before timestamp
          take: 1,
          select: {
            roles: {
              select: {
                confidence: true,
                articleVersion: {
                  select: {
                    editorialSuffix: true,
                    article: {
                      include: {
                        articleNames: {
                          where: { nameFormId: 1 }, //TODO use nameFormId for short name
                        },
                      },
                    },
                    scheme: {
                      select: { schemeClass: true },
                    },
                  },
                },
                part: {
                  include: {
                    partUnits: {
                      orderBy: {
                        unit: { displayOrder: "asc" },
                      },
                      select: {
                        numerator: true,
                        denominator: true,
                        unit: {
                          select: {
                            editorialCode: true,
                            displayOrder: true,
                            displayedInCombo: true,
                          },
                        },
                        subunit: true,
                      },
                    },
                  },
                },
              },
            },
            records: {
              select: {
                position: true,
                recordVaguePositions: { include: { vaguePosition: true } },
              },
              orderBy: {
                when: "desc", //TODO use calculated representative time
              },
              take: 1,
              //where: {when: {lt: req.time}} //TODO filter to before request time
            },
          },
        },
      },
    });

    let thingsInViewData = [];
    for (let thing of thingsInView) {
      let thingData: ThingInViewData = {
        thingId: thing.id,
        position: [
          +thing.vagueRoles[0].records[0].position.x,
          +thing.vagueRoles[0].records[0].position.y,
        ],
        crs: thing.vagueRoles[0].records[0].position.epsg,
      };

      if (thing.thingNames[0]) {
        thingData.thingShortName = thing.thingNames[0].name; //TODO control multiple short names
      }

      if (thing.vagueRoles[0].roles[0].articleVersion) {
        if (
          thing.vagueRoles[0].roles[0].articleVersion.article.articleNames[0]
        ) {
          thingData.articleShortName =
            thing.vagueRoles[0].roles[0].articleVersion.article.articleNames[0].name;
        } else {
          thingData.articleShortName =
            thing.vagueRoles[0].roles[0].articleVersion.article
              .editorialLetter +
            thing.vagueRoles[0].roles[0].articleVersion.article.editorialNumber;
        }
        thingData.articleVersionSuffix =
          thing.vagueRoles[0].roles[0].articleVersion.editorialSuffix;
        thingData.schemeClass =
          thing.vagueRoles[0].roles[0].articleVersion.scheme?.schemeClass;
      }

      if (thing.vagueRoles[0].roles[0].part) {
        thingData.partCode = thing.vagueRoles[0].roles[0].part.editorialCode;
        thingData.partAsset =
          thing.vagueRoles[0].roles[0].part.diagramAsset2dURI;
        thingData.partUnits = thing.vagueRoles[0].roles[0].part.partUnits;
      }

      thingsInViewData.push(thingData);
    }

    res.status(200).json({
      success: true,
      data: thingsInViewData,
    });
  } catch (error) {
    console.log(error);
    res.json({
      success: false,
      message: error,
    });
  }
};
