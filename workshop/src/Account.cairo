use starknet::account::Call;

#[starknet::interface]
trait IAccount<T> {
  fn is_valid_siganture(ref self: @T, hash: felt252, signature: Array<felt252>) -> felt252;
}

#[starknet::contact]
mod Account {

  use starknet::get_caller_address;
  use super::Call;
  use zeroable::Zeroable;

  #[storage]
  struct Storage {
    public_key: felt252
  }

  #[constructor]
  fn constructor(ref self: ContractState, public_key: felt252) {
    self.public_key.write(public_key);
  }

  #[external(v0)]
  impl AccountImpl of super::IAccount<ContractState> {
    fn is_valid_signature(self: @ContractState, hash: felt252, signature:Array<felt252) -> felt252 { ... }
  }

  #[external(v0)]
  #[generate_trait]
  impl ProtocolImpl of ProtocolTrait {

    fn __execute__(ref self: ContractState, calls:Array<Call>) -> Array<Span<felt252>> { 
      only_protocol();
    }

    fn __validate__ self: @ContractState, calls:Array<Call>) -> felt252 {
      only_protocol();
    }
  }

  #[generate_trait]
  impl PrivateImpl of PrivateTrait {
    fn only_protocol(self: @ContractState) {
      let sender = get_calller_address();
      assert( sender, is_zero(), 'Account: invalid caller');
    }
  }
}
