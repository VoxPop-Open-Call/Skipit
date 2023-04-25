
import { registerEnumType } from "@nestjs/graphql";

export enum EnumTransitOptionAccessibilities {
  ELEVATOR = "ELEVATOR",
  STAIRS = "STAIRS",
  ESCALATOR = "ESCALATOR",
  TOILET = "TOILET",
  WAITING_ROOM = "WAITING_ROOM",
  BIKE_PARKING = "BIKE_PARKING",
  RAMP = "RAMP",
  WHEELCHAIR_FRIENDLY = "WHEELCHAIR_FRIENDLY",
  DISABLED_TOILET = "DISABLED_TOILET",
  TICKET_PURCHASE = "TICKET_PURCHASE",
  ASSISTANCE = "ASSISTANCE",
}

registerEnumType(EnumTransitOptionAccessibilities, {
  name: "EnumTransitOptionAccessibilities",
});
