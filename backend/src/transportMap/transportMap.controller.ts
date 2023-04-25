import * as common from "@nestjs/common";
import * as swagger from "@nestjs/swagger";
import * as nestAccessControl from "nest-access-control";
import { TransportMapService } from "./transportMap.service";
import { TransportMapControllerBase } from "./base/transportMap.controller.base";

@swagger.ApiTags("transportMaps")
@common.Controller("transportMaps")
export class TransportMapController extends TransportMapControllerBase {
  constructor(
    protected readonly service: TransportMapService,
    @nestAccessControl.InjectRolesBuilder()
    protected readonly rolesBuilder: nestAccessControl.RolesBuilder
  ) {
    super(service, rolesBuilder);
  }
}
