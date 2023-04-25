
import { registerEnumType } from "@nestjs/graphql";

export enum EnumTransitOptionTransportTypes {
  BUS = "BUS",
  TRAM = "TRAM",
  TRAIN = "TRAIN",
  FERRY = "FERRY",
  METRO = "METRO",
}

registerEnumType(EnumTransitOptionTransportTypes, {
  name: "EnumTransitOptionTransportTypes",
});
