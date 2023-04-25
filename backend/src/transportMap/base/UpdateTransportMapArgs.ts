
import { ArgsType, Field } from "@nestjs/graphql";
import { TransportMapWhereUniqueInput } from "./TransportMapWhereUniqueInput";
import { TransportMapUpdateInput } from "./TransportMapUpdateInput";

@ArgsType()
class UpdateTransportMapArgs {
  @Field(() => TransportMapWhereUniqueInput, { nullable: false })
  where!: TransportMapWhereUniqueInput;
  @Field(() => TransportMapUpdateInput, { nullable: false })
  data!: TransportMapUpdateInput;
}

export { UpdateTransportMapArgs as UpdateTransportMapArgs };
