
import { ArgsType, Field } from "@nestjs/graphql";
import { TransportMapWhereUniqueInput } from "./TransportMapWhereUniqueInput";

@ArgsType()
class TransportMapFindUniqueArgs {
  @Field(() => TransportMapWhereUniqueInput, { nullable: false })
  where!: TransportMapWhereUniqueInput;
}

export { TransportMapFindUniqueArgs as TransportMapFindUniqueArgs };
