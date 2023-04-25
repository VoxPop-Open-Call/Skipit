
import { ArgsType, Field } from "@nestjs/graphql";
import { ApiProperty } from "@nestjs/swagger";
import { TransitOptionWhereInput } from "./TransitOptionWhereInput";
import { Type } from "class-transformer";
import { TransitOptionOrderByInput } from "./TransitOptionOrderByInput";

@ArgsType()
class TransitOptionFindManyArgs {
  @ApiProperty({
    required: false,
    type: () => TransitOptionWhereInput,
  })
  @Field(() => TransitOptionWhereInput, { nullable: true })
  @Type(() => TransitOptionWhereInput)
  where?: TransitOptionWhereInput;

  @ApiProperty({
    required: false,
    type: [TransitOptionOrderByInput],
  })
  @Field(() => [TransitOptionOrderByInput], { nullable: true })
  @Type(() => TransitOptionOrderByInput)
  orderBy?: Array<TransitOptionOrderByInput>;

  @ApiProperty({
    required: false,
    type: Number,
  })
  @Field(() => Number, { nullable: true })
  @Type(() => Number)
  skip?: number;

  @ApiProperty({
    required: false,
    type: Number,
  })
  @Field(() => Number, { nullable: true })
  @Type(() => Number)
  take?: number;
}

export { TransitOptionFindManyArgs as TransitOptionFindManyArgs };
