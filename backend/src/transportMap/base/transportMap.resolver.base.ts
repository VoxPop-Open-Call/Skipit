
import * as graphql from "@nestjs/graphql";
import * as apollo from "apollo-server-express";
import { isRecordNotFoundError } from "../../prisma.util";
import { MetaQueryPayload } from "../../util/MetaQueryPayload";
import * as nestAccessControl from "nest-access-control";
import * as gqlACGuard from "../../auth/gqlAC.guard";
import { GqlDefaultAuthGuard } from "../../auth/gqlDefaultAuth.guard";
import * as common from "@nestjs/common";
import { Public } from "../../decorators/public.decorator";
import { AclValidateRequestInterceptor } from "../../interceptors/aclValidateRequest.interceptor";
import { CreateTransportMapArgs } from "./CreateTransportMapArgs";
import { UpdateTransportMapArgs } from "./UpdateTransportMapArgs";
import { DeleteTransportMapArgs } from "./DeleteTransportMapArgs";
import { TransportMapFindManyArgs } from "./TransportMapFindManyArgs";
import { TransportMapFindUniqueArgs } from "./TransportMapFindUniqueArgs";
import { TransportMap } from "./TransportMap";
import { TransportMapService } from "../transportMap.service";
@common.UseGuards(GqlDefaultAuthGuard, gqlACGuard.GqlACGuard)
@graphql.Resolver(() => TransportMap)
export class TransportMapResolverBase {
  constructor(
    protected readonly service: TransportMapService,
    protected readonly rolesBuilder: nestAccessControl.RolesBuilder
  ) {}

  @Public()
  @graphql.Query(() => MetaQueryPayload)
  async _transportMapsMeta(
    @graphql.Args() args: TransportMapFindManyArgs
  ): Promise<MetaQueryPayload> {
    const results = await this.service.count({
      ...args,
      skip: undefined,
      take: undefined,
    });
    return {
      count: results,
    };
  }

  @Public()
  @graphql.Query(() => [TransportMap])
  async transportMaps(
    @graphql.Args() args: TransportMapFindManyArgs
  ): Promise<TransportMap[]> {
    return this.service.findMany(args);
  }

  @Public()
  @graphql.Query(() => TransportMap, { nullable: true })
  async transportMap(
    @graphql.Args() args: TransportMapFindUniqueArgs
  ): Promise<TransportMap | null> {
    const result = await this.service.findOne(args);
    if (result === null) {
      return null;
    }
    return result;
  }

  @common.UseInterceptors(AclValidateRequestInterceptor)
  @graphql.Mutation(() => TransportMap)
  @nestAccessControl.UseRoles({
    resource: "TransportMap",
    action: "create",
    possession: "any",
  })
  async createTransportMap(
    @graphql.Args() args: CreateTransportMapArgs
  ): Promise<TransportMap> {
    return await this.service.create({
      ...args,
      data: args.data,
    });
  }

  @common.UseInterceptors(AclValidateRequestInterceptor)
  @graphql.Mutation(() => TransportMap)
  @nestAccessControl.UseRoles({
    resource: "TransportMap",
    action: "update",
    possession: "any",
  })
  async updateTransportMap(
    @graphql.Args() args: UpdateTransportMapArgs
  ): Promise<TransportMap | null> {
    try {
      return await this.service.update({
        ...args,
        data: args.data,
      });
    } catch (error) {
      if (isRecordNotFoundError(error)) {
        throw new apollo.ApolloError(
          `No resource was found for ${JSON.stringify(args.where)}`
        );
      }
      throw error;
    }
  }

  @graphql.Mutation(() => TransportMap)
  @nestAccessControl.UseRoles({
    resource: "TransportMap",
    action: "delete",
    possession: "any",
  })
  async deleteTransportMap(
    @graphql.Args() args: DeleteTransportMapArgs
  ): Promise<TransportMap | null> {
    try {
      return await this.service.delete(args);
    } catch (error) {
      if (isRecordNotFoundError(error)) {
        throw new apollo.ApolloError(
          `No resource was found for ${JSON.stringify(args.where)}`
        );
      }
      throw error;
    }
  }
}
