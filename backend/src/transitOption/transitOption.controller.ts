import * as common from "@nestjs/common";
import * as swagger from "@nestjs/swagger";
import * as nestAccessControl from "nest-access-control";
import { TransitOptionService } from "./transitOption.service";
import { TransitOptionControllerBase } from "./base/transitOption.controller.base";

@swagger.ApiTags("transitOptions")
@common.Controller("transitOptions")
export class TransitOptionController extends TransitOptionControllerBase {
  constructor(
    protected readonly service: TransitOptionService,
    @nestAccessControl.InjectRolesBuilder()
    protected readonly rolesBuilder: nestAccessControl.RolesBuilder
  ) {
    super(service, rolesBuilder);
  }
}
