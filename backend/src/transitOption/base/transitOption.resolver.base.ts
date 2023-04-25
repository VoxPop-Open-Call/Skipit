
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
import { CreateTransitOptionArgs } from "./CreateTransitOptionArgs";
import { UpdateTransitOptionArgs } from "./UpdateTransitOptionArgs";
import { DeleteTransitOptionArgs } from "./DeleteTransitOptionArgs";
import { TransitOptionFindManyArgs } from "./TransitOptionFindManyArgs";
import { TransitOptionFindUniqueArgs } from "./TransitOptionFindUniqueArgs";
import { TransitOption } from "./TransitOption";
import { TransitOptionService } from "../transitOption.service";
@common.UseGuards(GqlDefaultAuthGuard, gqlACGuard.GqlACGuard)
@graphql.Resolver(() => TransitOption)
export class TransitOptionResolverBase {
  constructor(
    protected readonly service: TransitOptionService,
    protected readonly rolesBuilder: nestAccessControl.RolesBuilder
  ) {}

  @Public()
  @graphql.Query(() => MetaQueryPayload)
  async _transitOptionsMeta(
    @graphql.Args() args: TransitOptionFindManyArgs
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
  @graphql.Query(() => [TransitOption])
  async transitOptions(
    @graphql.Args() args: TransitOptionFindManyArgs
  ): Promise<TransitOption[]> {
    return this.service.findMany(args);
  }

  @Public()
  @graphql.Query(() => TransitOption, { nullable: true })
  async transitOption(
    @graphql.Args() args: TransitOptionFindUniqueArgs
  ): Promise<TransitOption | null> {
    const result = await this.service.findOne(args);
    if (result === null) {
      return null;
    }
    return result;
  }

  @common.UseInterceptors(AclValidateRequestInterceptor)
  @graphql.Mutation(() => TransitOption)
  @nestAccessControl.UseRoles({
    resource: "TransitOption",
    action: "create",
    possession: "any",
  })
  async createTransitOption(
    @graphql.Args() args: CreateTransitOptionArgs
  ): Promise<TransitOption> {
    return await this.service.create({
      ...args,
      data: args.data,
    });
  }

  @common.UseInterceptors(AclValidateRequestInterceptor)
  @graphql.Mutation(() => TransitOption)
  @nestAccessControl.UseRoles({
    resource: "TransitOption",
    action: "update",
    possession: "any",
  })
  async updateTransitOption(
    @graphql.Args() args: UpdateTransitOptionArgs
  ): Promise<TransitOption | null> {
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

  @graphql.Mutation(() => TransitOption)
  @nestAccessControl.UseRoles({
    resource: "TransitOption",
    action: "delete",
    possession: "any",
  })
  async deleteTransitOption(
    @graphql.Args() args: DeleteTransitOptionArgs
  ): Promise<TransitOption | null> {
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
