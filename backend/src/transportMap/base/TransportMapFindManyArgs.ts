
import { ArgsType, Field } from "@nestjs/graphql";
import { ApiProperty } from "@nestjs/swagger";
import { TransportMapWhereInput } from "./TransportMapWhereInput";
import { Type } from "class-transformer";
import { TransportMapOrderByInput } from "./TransportMapOrderByInput";

@ArgsType()
class TransportMapFindManyArgs {
  @ApiProperty({
    required: false,
    type: () => TransportMapWhereInput,
  })
  @Field(() => TransportMapWhereInput, { nullable: true })
  @Type(() => TransportMapWhereInput)
  where?: TransportMapWhereInput;

  @ApiProperty({
    required: false,
    type: [TransportMapOrderByInput],
  })
  @Field(() => [TransportMapOrderByInput], { nullable: true })
  @Type(() => TransportMapOrderByInput)
  orderBy?: Array<TransportMapOrderByInput>;

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

export { TransportMapFindManyArgs as TransportMapFindManyArgs };
