import { Injectable } from "@nestjs/common";
import { PrismaService } from "../prisma/prisma.service";
import { TransitOptionServiceBase } from "./base/transitOption.service.base";

@Injectable()
export class TransitOptionService extends TransitOptionServiceBase {
  constructor(protected readonly prisma: PrismaService) {
    super(prisma);
  }
}
