
import { ObjectType, Field } from "@nestjs/graphql";
import { ApiProperty } from "@nestjs/swagger";
import { EnumTransitOptionAccessibilities } from "./EnumTransitOptionAccessibilities";
import { IsEnum, IsOptional, IsDate, IsString } from "class-validator";
import { Type } from "class-transformer";
import { EnumTransitOptionTransportTypes } from "./EnumTransitOptionTransportTypes";

@ObjectType()
class TransitOption {
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
    required: true,
  })
  @IsDate()
  @Type(() => Date)
  @Field(() => Date)
  createdAt!: Date;

  @ApiProperty({
    required: true,
    type: String,
  })
  @IsString()
  @Field(() => String)
  id!: string;

  @ApiProperty({
    required: false,
    type: String,
  })
  @IsString()
  @IsOptional()
  @Field(() => String, {
    nullable: true,
  })
  name!: string | null;

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

  @ApiProperty({
    required: true,
  })
  @IsDate()
  @Type(() => Date)
  @Field(() => Date)
  updatedAt!: Date;
}

export { TransitOption as TransitOption };
