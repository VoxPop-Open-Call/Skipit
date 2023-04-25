
import { PrismaService } from "../../prisma/prisma.service";
import { Prisma, TransportMap } from "@prisma/client";

export class TransportMapServiceBase {
  constructor(protected readonly prisma: PrismaService) {}

  async count<T extends Prisma.TransportMapFindManyArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransportMapFindManyArgs>
  ): Promise<number> {
    return this.prisma.transportMap.count(args);
  }

  async findMany<T extends Prisma.TransportMapFindManyArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransportMapFindManyArgs>
  ): Promise<TransportMap[]> {
    return this.prisma.transportMap.findMany(args);
  }
  async findOne<T extends Prisma.TransportMapFindUniqueArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransportMapFindUniqueArgs>
  ): Promise<TransportMap | null> {
    return this.prisma.transportMap.findUnique(args);
  }
  async create<T extends Prisma.TransportMapCreateArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransportMapCreateArgs>
  ): Promise<TransportMap> {
    return this.prisma.transportMap.create<T>(args);
  }
  async update<T extends Prisma.TransportMapUpdateArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransportMapUpdateArgs>
  ): Promise<TransportMap> {
    return this.prisma.transportMap.update<T>(args);
  }
  async delete<T extends Prisma.TransportMapDeleteArgs>(
    args: Prisma.SelectSubset<T, Prisma.TransportMapDeleteArgs>
  ): Promise<TransportMap> {
    return this.prisma.transportMap.delete(args);
  }
}
