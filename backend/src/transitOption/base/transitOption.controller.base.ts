
import * as common from "@nestjs/common";
import * as swagger from "@nestjs/swagger";
import { isRecordNotFoundError } from "../../prisma.util";
import * as errors from "../../errors";
import { Request } from "express";
import { plainToClass } from "class-transformer";
import { ApiNestedQuery } from "../../decorators/api-nested-query.decorator";
import * as nestAccessControl from "nest-access-control";
import * as defaultAuthGuard from "../../auth/defaultAuth.guard";
import { TransitOptionService } from "../transitOption.service";
import { AclValidateRequestInterceptor } from "../../interceptors/aclValidateRequest.interceptor";
import { Public } from "../../decorators/public.decorator";
import { TransitOptionCreateInput } from "./TransitOptionCreateInput";
import { TransitOptionWhereInput } from "./TransitOptionWhereInput";
import { TransitOptionWhereUniqueInput } from "./TransitOptionWhereUniqueInput";
import { TransitOptionFindManyArgs } from "./TransitOptionFindManyArgs";
import { TransitOptionUpdateInput } from "./TransitOptionUpdateInput";
import { TransitOption } from "./TransitOption";

@swagger.ApiBearerAuth()
@common.UseGuards(defaultAuthGuard.DefaultAuthGuard, nestAccessControl.ACGuard)
export class TransitOptionControllerBase {
  constructor(
    protected readonly service: TransitOptionService,
    protected readonly rolesBuilder: nestAccessControl.RolesBuilder
  ) {}
  @common.UseInterceptors(AclValidateRequestInterceptor)
  @common.Post()
  @swagger.ApiCreatedResponse({ type: TransitOption })
  @nestAccessControl.UseRoles({
    resource: "TransitOption",
    action: "create",
    possession: "any",
  })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async create(
    @common.Body() data: TransitOptionCreateInput
  ): Promise<TransitOption> {
    return await this.service.create({
      data: data,
      select: {
        accessibilities: true,
        createdAt: true,
        id: true,
        name: true,
        transportTypes: true,
        updatedAt: true,
      },
    });
  }

  @Public()
  @common.Get()
  @swagger.ApiOkResponse({ type: [TransitOption] })
  @ApiNestedQuery(TransitOptionFindManyArgs)
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async findMany(@common.Req() request: Request): Promise<TransitOption[]> {
    const args = plainToClass(TransitOptionFindManyArgs, request.query);
    return this.service.findMany({
      ...args,
      select: {
        accessibilities: true,
        createdAt: true,
        id: true,
        name: true,
        transportTypes: true,
        updatedAt: true,
      },
    });
  }

  @Public()
  @common.Get("/:id")
  @swagger.ApiOkResponse({ type: TransitOption })
  @swagger.ApiNotFoundResponse({ type: errors.NotFoundException })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async findOne(
    @common.Param() params: TransitOptionWhereUniqueInput
  ): Promise<TransitOption | null> {
    const result = await this.service.findOne({
      where: params,
      select: {
        accessibilities: true,
        createdAt: true,
        id: true,
        name: true,
        transportTypes: true,
        updatedAt: true,
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
  @swagger.ApiOkResponse({ type: TransitOption })
  @swagger.ApiNotFoundResponse({ type: errors.NotFoundException })
  @nestAccessControl.UseRoles({
    resource: "TransitOption",
    action: "update",
    possession: "any",
  })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async update(
    @common.Param() params: TransitOptionWhereUniqueInput,
    @common.Body() data: TransitOptionUpdateInput
  ): Promise<TransitOption | null> {
    try {
      return await this.service.update({
        where: params,
        data: data,
        select: {
          accessibilities: true,
          createdAt: true,
          id: true,
          name: true,
          transportTypes: true,
          updatedAt: true,
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
  @swagger.ApiOkResponse({ type: TransitOption })
  @swagger.ApiNotFoundResponse({ type: errors.NotFoundException })
  @nestAccessControl.UseRoles({
    resource: "TransitOption",
    action: "delete",
    possession: "any",
  })
  @swagger.ApiForbiddenResponse({
    type: errors.ForbiddenException,
  })
  async delete(
    @common.Param() params: TransitOptionWhereUniqueInput
  ): Promise<TransitOption | null> {
    try {
      return await this.service.delete({
        where: params,
        select: {
          accessibilities: true,
          createdAt: true,
          id: true,
          name: true,
          transportTypes: true,
          updatedAt: true,
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
