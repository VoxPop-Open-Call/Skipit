import { Module } from "@nestjs/common";
import { TransitOptionModuleBase } from "./base/transitOption.module.base";
import { TransitOptionService } from "./transitOption.service";
import { TransitOptionController } from "./transitOption.controller";
import { TransitOptionResolver } from "./transitOption.resolver";

@Module({
  imports: [TransitOptionModuleBase],
  controllers: [TransitOptionController],
  providers: [TransitOptionService, TransitOptionResolver],
  exports: [TransitOptionService],
})
export class TransitOptionModule {}
