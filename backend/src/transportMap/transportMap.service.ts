import { Injectable } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { TransportMapServiceBase } from "./base/transportMap.service.base";

@Injectable()
export class TransportMapService extends TransportMapServiceBase {
  constructor(protected readonly prisma: PrismaService) {
    super(prisma);
  }
}
