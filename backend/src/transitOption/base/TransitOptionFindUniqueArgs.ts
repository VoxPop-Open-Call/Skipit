
import { ArgsType, Field } from "@nestjs/graphql";
import { TransitOptionWhereUniqueInput } from "./TransitOptionWhereUniqueInput";

@ArgsType()
class TransitOptionFindUniqueArgs {
  @Field(() => TransitOptionWhereUniqueInput, { nullable: false })
  where!: TransitOptionWhereUniqueInput;
}

export { TransitOptionFindUniqueArgs as TransitOptionFindUniqueArgs };
