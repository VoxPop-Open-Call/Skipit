
import * as common from "@nestjs/common";
import * as swagger from "@nestjs/swagger";
import { isRecordNotFoundError } from "../../prisma.util";
import * as errors from "../../errors";
import { Request } from "express";
import { plainToClass } from "class-transformer";
import { ApiNestedQuery } from "../../decorators/api-nested-query.decorator";
import * as nestAccessControl from "nest-access-control";
import * as defaultAuthGuard from "../../auth/defaultAuth.guard";
import { TransportMapService } from "../transportMap.service";
import { AclValidateRequestInterceptor } from "../../interceptors/aclValidateRequest.interceptor";
import { Public } from "../../decorators/public.decorator";
import { TransportMapCreateInput } from "./TransportMapCreateInput";
import { TransportMapWhereInput } from "./TransportMapWhereInput";
import { TransportMapWhereUniqueInput } from "./TransportMapWhereUniqueInput";
import { TransportMapFindManyArgs } from "./TransportMapFindManyArgs";
import { TransportMapUpdateInput } from "./TransportMapUpdateInput";
import { TransportMap } from "./TransportMap";

@swagger.ApiBearerAuth()
@common.UseGuards(defaultAuthGuard.DefaultAuthGuard, nestAccessControl.ACGuard)
export class TransportMapControllerBase {
  constructor(
    protected readonly service: TransportMapService,
    protected readonly rolesBuilder: nestAccessControl.RolesBuilder
  ) {}
  @common.UseInterceptors(AclValidateRequestInterceptor)
  @common.Post()
  @swagger.ApiCreatedResponse({ type: TransportMap })
  @nestAccessControl.UseRoles({
    resource: "TransportMap",
    action: "create",
    possession: "any",
  })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async create(
    @common.Body() data: TransportMapCreateInput
  ): Promise<TransportMap> {
    return await this.service.create({
      data: data,
      select: {
        createdAt: true,
        icon: true,
        id: true,
        name: true,
        thumbnailUrl: true,
        updatedAt: true,
        url: true,
      },
    });
  }

  @Public()
  @common.Get()
  @swagger.ApiOkResponse({ type: [TransportMap] })
  @ApiNestedQuery(TransportMapFindManyArgs)
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async findMany(@common.Req() request: Request): Promise<TransportMap[]> {
    const args = plainToClass(TransportMapFindManyArgs, request.query);
    return this.service.findMany({
      ...args,
      select: {
        createdAt: true,
        icon: true,
        id: true,
        name: true,
        thumbnailUrl: true,
        updatedAt: true,
        url: true,
      },
    });
  }

  @Public()
  @common.Get("/:id")
  @swagger.ApiOkResponse({ type: TransportMap })
  @swagger.ApiNotFoundResponse({ type: errors.NotFoundException })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async findOne(
    @common.Param() params: TransportMapWhereUniqueInput
  ): Promise<TransportMap | null> {
    const result = await this.service.findOne({
      where: params,
      select: {
        createdAt: true,
        icon: true,
        id: true,
        name: true,
        thumbnailUrl: true,
        updatedAt: true,
        url: true,
      },
    });
    if (result === null) {
      throw new errors.NotFoundException(
        `No resource was found for ${JSON.stringify(params)}`
      );
    }
    return result;
  }

  @common.UseInterceptors(AclValidateRequestInterceptor)
  @common.Patch("/:id")
  @swagger.ApiOkResponse({ type: TransportMap })
  @swagger.ApiNotFoundResponse({ type: errors.NotFoundException })
  @nestAccessControl.UseRoles({
    resource: "TransportMap",
    action: "update",
    possession: "any",
  })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async update(
    @common.Param() params: TransportMapWhereUniqueInput,
    @common.Body() data: TransportMapUpdateInput
  ): Promise<TransportMap | null> {
    try {
      return await this.service.update({
        where: params,
        data: data,
        select: {
          createdAt: true,
          icon: true,
          id: true,
          name: true,
          thumbnailUrl: true,
          updatedAt: true,
          url: true,
        },
      });
    } catch (error) {
      if (isRecordNotFoundError(error)) {
        throw new errors.NotFoundException(
          `No resource was found for ${JSON.stringify(params)}`
        );
      }
      throw error;
    }
  }

  @common.Delete("/:id")
  @swagger.ApiOkResponse({ type: TransportMap })
  @swagger.ApiNotFoundResponse({ type: errors.NotFoundException })
  @nestAccessControl.UseRoles({
    resource: "TransportMap",
    action: "delete",
    possession: "any",
  })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async delete(
    @common.Param() params: TransportMapWhereUniqueInput
  ): Promise<TransportMap | null> {
    try {
      return await this.service.delete({
        where: params,
        select: {
          createdAt: true,
          icon: true,
          id: true,
          name: true,
          thumbnailUrl: true,
          updatedAt: true,
          url: true,
        },
      });
    } catch (error) {
      if (isRecordNotFoundError(error)) {
        throw new errors.NotFoundException(
          `No resource was found for ${JSON.stringify(params)}`
        );
      }
      throw error;
    }
  }
}
