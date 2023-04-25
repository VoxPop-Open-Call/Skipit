
import { ArgsType, Field } from "@nestjs/graphql";
import { TransitOptionWhereUniqueInput } from "./TransitOptionWhereUniqueInput";
import { TransitOptionUpdateInput } from "./TransitOptionUpdateInput";

@ArgsType()
class UpdateTransitOptionArgs {
  @Field(() => TransitOptionWhereUniqueInput, { nullable: false })
  where!: TransitOptionWhereUniqueInput;
  @Field(() => TransitOptionUpdateInput, { nullable: false })
  data!: TransitOptionUpdateInput;
}

export { UpdateTransitOptionArgs as UpdateTransitOptionArgs };
