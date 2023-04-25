import { ArgsType, Field } from "@nestjs/graphql";
import { TransitOptionCreateInput } from "./TransitOptionCreateInput";

@ArgsType()
class CreateTransitOptionArgs {
  @Field(() => TransitOptionCreateInput, { nullable: false })
  data!: TransitOptionCreateInput;
}

export { CreateTransitOptionArgs as CreateTransitOptionArgs };
