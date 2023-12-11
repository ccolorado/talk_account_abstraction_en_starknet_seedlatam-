#[starknet::contact]
mod Account {

  trait ISRC6<T> {
    fn __execute__(ref self: T, calls: Array<Call>) -> Array<Span<felt252>;
    fn __validate__(ref self: T, calls: Array<Call>) -> felt252;
    fn is_valid_siganture(ref self: @T, hash: felt252, signature: Array<felt252>) -> felt252;
  }

  #[storage]
  struct Storage {
    public_key: felt252
  }

}
