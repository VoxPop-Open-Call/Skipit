
import { InputType, Field } from "@nestjs/graphql";
import { ApiProperty } from "@nestjs/swagger";
import { EnumTransitOptionAccessibilities } from "./EnumTransitOptionAccessibilities";
import { IsEnum, IsOptional, IsString } from "class-validator";
import { EnumTransitOptionTransportTypes } from "./EnumTransitOptionTransportTypes";

@InputType()
class TransitOptionCreateInput {
  @ApiProperty({
    required: false,
    enum: EnumTransitOptionAccessibilities,
    isArray: true,
  })
  @IsEnum(EnumTransitOptionAccessibilities, {
    each: true,
  })
  @IsOptional()
  @Field(() => [EnumTransitOptionAccessibilities], {
    nullable: true,
  })
  accessibilities?: Array<
    | "ELEVATOR"
    | "STAIRS"
    | "ESCALATOR"
    | "TOILET"
    | "WAITING_ROOM"
    | "BIKE_PARKING"
    | "RAMP"
    | "WHEELCHAIR_FRIENDLY"
    | "DISABLED_TOILET"
    | "TICKET_PURCHASE"
    | "ASSISTANCE"
  >;

  @ApiProperty({
    required: false,
    type: String,
  })
  @IsString()
  @IsOptional()
  @Field(() => String, {
    nullable: true,
  })
  name?: string | null;

  @ApiProperty({
    required: false,
    enum: EnumTransitOptionTransportTypes,
    isArray: true,
  })
  @IsEnum(EnumTransitOptionTransportTypes, {
    each: true,
  })
  @IsOptional()
  @Field(() => [EnumTransitOptionTransportTypes], {
    nullable: true,
  })
  transportTypes?: Array<"BUS" | "TRAM" | "TRAIN" | "FERRY" | "METRO">;
}

export { TransitOptionCreateInput as TransitOptionCreateInput };
