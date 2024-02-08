import { ArticleName, Prisma, PrismaClient } from "@prisma/client";
import { DefaultArgs } from "@prisma/client/runtime/library";
import { Request, Response } from "express";
const thingClient = new PrismaClient().thing;

type ThingInViewData = {
  /// mandatory
  thingId: number;
  position: [number, number];
  crs: number;
  /// basic optionals
  thingShortName?: string;
  articleShortName?: string;
  articleVersionSuffix?: string;
  partCode?: string | null;
  partAsset?: string | null;
  partUnits?: unknown[];
  schemeClass?: string;
};

type ThingSummaryData = {
  /// mandatory
  thingId: number;
  position: [number, number];
  crs: number;
  firstRecord: Date;
  lastRecord: Date;
  /// basic optionals
  thingShortName?: string;
  articleShortName?: string;
  articleVersionSuffix?: string;
  partCode?: string | null;
  partAsset?: string | null;
  partUnits?: unknown[];
  schemeClass?: string;
  /// detail optionals
  thingFullName?: string;
  articleFullNames?: string[];
  partDescription?: string;
  buildDetails?: string[];
  firstRecordDetail?: string;
  lastRecordDetail?: string;
  possibleRoles?: unknown[];
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

      addBasicOptionals(thing, thingData);

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

export const getThingSummary = async (req: Request, res: Response) => {
  try {
    console.log(req);

    if (!req.query.thingId) throw new Error("No ID supplied");

    let id = +req.query.thingId;

    const thing = await thingClient.findUnique({
      select: {
        id: true,
        thingNames: true, // TODO select best
        summary: true,
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
                when: true,
                earliest: true,
                latest: true,
                live: true,
                note: true,
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
      where: { id: id },
    });

    let thingsInViewData = [];

    if (!thing) throw new Error("No ID match");

    let thingData: ThingSummaryData = {
      thingId: thing.id,
      position: [
        +thing.vagueRoles[0].records[0].position.x,
        +thing.vagueRoles[0].records[0].position.y,
      ],
      crs: thing.vagueRoles[0].records[0].position.epsg,
      firstRecord: thing.vagueRoles[0].records.slice(-1)[0].latest, //TODO more
      lastRecord: thing.vagueRoles[0].records[0].earliest, //TODO more
    };

    addBasicOptionals(thing, thingData);

    if (thing.summary) {
      thingData.thingFullName = thing.summary;
    }

    //TODO deal with multiple vagueroles etc
    if (thing.vagueRoles[0].roles[0].articleVersion) {
      thingData.articleFullNames = [];
      for (let nameEntry of thing.vagueRoles[0].roles[0].articleVersion.article
        .articleNames) {
        thingData.articleFullNames.push(nameEntry.name);
      }
    }

    if (thing.vagueRoles[0].roles[0].part) {
      thingData.partDescription = thing.vagueRoles[0].roles[0].part.description;
    }

    //TODO buildDetails?: string[];

    if (thing.vagueRoles[0].records.slice(-1)[0].note)
      thingData.firstRecordDetail = thing.vagueRoles[0].records.slice(-1)[0]
        .note as string; //TODO more, and note type override

    if (thing.vagueRoles[0].records[0].note)
      thingData.lastRecordDetail = thing.vagueRoles[0].records[0].note; //TODO more
    // buildDetails
    // firstRecordDetail?: string;
    // lastRecordDetail?: string;
    // possibleRoles?: unknown[];

    thingsInViewData.push(thingData);

    res.status(200).json({
      success: true,
      data: thingsInViewData,
    });
  } catch (error) {
    console.log(error);
    let message = "Something went wrong";
    if (error && error instanceof Error) message = error.message;
    res.json({
      success: false,
      message: message,
    });
  }
};

const addBasicOptionals = (
  thing: any, //TODO investigate passing type created by client - currently would need to copy this code into getThingsInView to validate
  thingData: ThingInViewData | ThingSummaryData
) => {
  if (thing.thingNames[0]) {
    thingData.thingShortName = thing.thingNames[0].name; //TODO control multiple short names
  }

  if (thing.vagueRoles[0].roles[0].articleVersion) {
    if (thing.vagueRoles[0].roles[0].articleVersion.article.articleNames[0]) {
      thingData.articleShortName =
        thing.vagueRoles[0].roles[0].articleVersion.article.articleNames[0].name;
    } else {
      thingData.articleShortName =
        thing.vagueRoles[0].roles[0].articleVersion.article.editorialLetter +
        thing.vagueRoles[0].roles[0].articleVersion.article.editorialNumber;
    }
    thingData.articleVersionSuffix =
      thing.vagueRoles[0].roles[0].articleVersion.editorialSuffix;
    thingData.schemeClass =
      thing.vagueRoles[0].roles[0].articleVersion.scheme?.schemeClass;
  }

  if (thing.vagueRoles[0].roles[0].part) {
    thingData.partCode = thing.vagueRoles[0].roles[0].part.editorialCode;
    thingData.partAsset = thing.vagueRoles[0].roles[0].part.diagramAsset2dURI;
    thingData.partUnits = thing.vagueRoles[0].roles[0].part.partUnits;
  }
};
