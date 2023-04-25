
import { ArgsType, Field } from "@nestjs/graphql";
import { TransitOptionWhereUniqueInput } from "./TransitOptionWhereUniqueInput";

@ArgsType()
class DeleteTransitOptionArgs {
  @Field(() => TransitOptionWhereUniqueInput, { nullable: false })
  where!: TransitOptionWhereUniqueInput;
}

export { DeleteTransitOptionArgs as DeleteTransitOptionArgs };
