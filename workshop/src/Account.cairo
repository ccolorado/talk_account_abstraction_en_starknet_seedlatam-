#[starknet::contact]
mod Account {

  #[storage]
  struct Storage {
    public_key: felt252
  }

}
