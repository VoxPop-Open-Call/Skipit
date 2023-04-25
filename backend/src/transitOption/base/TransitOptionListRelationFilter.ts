
import { InputType, Field } from "@nestjs/graphql";
import { ApiProperty } from "@nestjs/swagger";
import { TransitOptionWhereInput } from "./TransitOptionWhereInput";
import { ValidateNested, IsOptional } from "class-validator";
import { Type } from "class-transformer";

@InputType()
class TransitOptionListRelationFilter {
  @ApiProperty({
    required: false,
    type: () => TransitOptionWhereInput,
  })
  @ValidateNested()
  @Type(() => TransitOptionWhereInput)
  @IsOptional()
  @Field(() => TransitOptionWhereInput, {
    nullable: true,
  })
  every?: TransitOptionWhereInput;

  @ApiProperty({
    required: false,
    type: () => TransitOptionWhereInput,
  })
  @ValidateNested()
  @Type(() => TransitOptionWhereInput)
  @IsOptional()
  @Field(() => TransitOptionWhereInput, {
    nullable: true,
  })
  some?: TransitOptionWhereInput;

  @ApiProperty({
    required: false,
    type: () => TransitOptionWhereInput,
  })
  @ValidateNested()
  @Type(() => TransitOptionWhereInput)
  @IsOptional()
  @Field(() => TransitOptionWhereInput, {
    nullable: true,
  })
  none?: TransitOptionWhereInput;
}
export { TransitOptionListRelationFilter as TransitOptionListRelationFilter };
