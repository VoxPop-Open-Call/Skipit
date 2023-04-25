import { Module } from "@nestjs/common";
import { TransportMapModuleBase } from "./base/transportMap.module.base";
import { TransportMapService } from "./transportMap.service";
import { TransportMapController } from "./transportMap.controller";
import { TransportMapResolver } from "./transportMap.resolver";

@Module({
  imports: [TransportMapModuleBase],
  controllers: [TransportMapController],
  providers: [TransportMapService, TransportMapResolver],
  exports: [TransportMapService],
})
export class TransportMapModule {}
