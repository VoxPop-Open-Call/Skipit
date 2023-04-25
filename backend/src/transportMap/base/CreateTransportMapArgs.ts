
import { ArgsType, Field } from "@nestjs/graphql";
import { TransportMapCreateInput } from "./TransportMapCreateInput";

@ArgsType()
class CreateTransportMapArgs {
  @Field(() => TransportMapCreateInput, { nullable: false })
  data!: TransportMapCreateInput;
}

export { CreateTransportMapArgs as CreateTransportMapArgs };
