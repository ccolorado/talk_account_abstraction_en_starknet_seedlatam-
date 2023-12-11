#[starknet::contact]
mod Account {

  trait ISRC6 {
    fn __execute__(calls: Array<Call>) -> Array<Span<felt252>;
    fn __validate__(calls: Array<Call>) -> felt252;
    fn is_valid_siganture(hash: felt252, signature: Array<felt252>) -> felt252;
  }

  #[storage]
  struct Storage {
    public_key: felt252
  }

}
