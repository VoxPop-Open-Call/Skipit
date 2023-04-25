
import { ArgsType, Field } from "@nestjs/graphql";
import { TransportMapWhereUniqueInput } from "./TransportMapWhereUniqueInput";

@ArgsType()
class DeleteTransportMapArgs {
  @Field(() => TransportMapWhereUniqueInput, { nullable: false })
  where!: TransportMapWhereUniqueInput;
}

export { DeleteTransportMapArgs as DeleteTransportMapArgs };
