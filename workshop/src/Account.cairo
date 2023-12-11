use starnet::account:Call;

#[starknet::interface]
trait IAccount<T> {
  fn is_valid_siganture(ref self: @T, hash: felt252, signature: Array<felt252>) -> felt252;
}

#[starknet::contact]
mod Account {
  use super::Call;

  #[storage]
  struct Storage {
    public_key: felt252
  }

  #[external(v0)]
  impl AccountImpl of super::IAccount<ContractState> {
    fn is_valid_signature(self: @ContractState, hash: felt252, signature:Array<felt252) -> felt252 { ... }
  }

  #[external(v0)]
  #[generate_trait]
  impl ProtocolImpl of PRotocolTrait {
    fn __execute__(ref self: ContractState, calls:Array<Call>) -> Array<Span<felt252>> { ... }
    fn __validate__ self: @ContractState, calls:Array<Call>) -> felt252 { ... }
  }

}
