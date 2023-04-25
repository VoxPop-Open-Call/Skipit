
import { PrismaService } from "../../prisma/prisma.service";
import { Prisma, TransitOption } from "@prisma/client";

export class TransitOptionServiceBase {
  constructor(protected readonly prisma: PrismaService) {}

  async count<T extends Prisma.TransitOptionFindManyArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransitOptionFindManyArgs>
  ): Promise<number> {
    return this.prisma.transitOption.count(args);
  }

  async findMany<T extends Prisma.TransitOptionFindManyArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransitOptionFindManyArgs>
  ): Promise<TransitOption[]> {
    return this.prisma.transitOption.findMany(args);
  }
  async findOne<T extends Prisma.TransitOptionFindUniqueArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransitOptionFindUniqueArgs>
  ): Promise<TransitOption | null> {
    return this.prisma.transitOption.findUnique(args);
  }
  async create<T extends Prisma.TransitOptionCreateArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransitOptionCreateArgs>
  ): Promise<TransitOption> {
    return this.prisma.transitOption.create<T>(args);
  }
  async update<T extends Prisma.TransitOptionUpdateArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransitOptionUpdateArgs>
  ): Promise<TransitOption> {
    return this.prisma.transitOption.update<T>(args);
  }
  async delete<T extends Prisma.TransitOptionDeleteArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransitOptionDeleteArgs>
  ): Promise<TransitOption> {
    return this.prisma.transitOption.delete(args);
  }
}
