
import { InputType, Field } from "@nestjs/graphql";
import { ApiProperty } from "@nestjs/swagger";
import { TransportMapWhereInput } from "./TransportMapWhereInput";
import { ValidateNested, IsOptional } from "class-validator";
import { Type } from "class-transformer";

@InputType()
class TransportMapListRelationFilter {
  @ApiProperty({
    required: false,
    type: () => TransportMapWhereInput,
  })
  @ValidateNested()
  @Type(() => TransportMapWhereInput)
  @IsOptional()
  @Field(() => TransportMapWhereInput, {
    nullable: true,
  })
  every?: TransportMapWhereInput;

  @ApiProperty({
    required: false,
    type: () => TransportMapWhereInput,
  })
  @ValidateNested()
  @Type(() => TransportMapWhereInput)
  @IsOptional()
  @Field(() => TransportMapWhereInput, {
    nullable: true,
  })
  some?: TransportMapWhereInput;

  @ApiProperty({
    required: false,
    type: () => TransportMapWhereInput,
  })
  @ValidateNested()
  @Type(() => TransportMapWhereInput)
  @IsOptional()
  @Field(() => TransportMapWhereInput, {
    nullable: true,
  })
  none?: TransportMapWhereInput;
}
export { TransportMapListRelationFilter as TransportMapListRelationFilter };
