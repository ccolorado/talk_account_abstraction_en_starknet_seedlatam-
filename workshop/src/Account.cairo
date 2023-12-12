use starknet::account::Call;

#[starknet::interface]
trait IAccount<T> {
  fn is_valid_siganture(ref self: @T, hash: felt252, signature: Array<felt252>) -> felt252;
}

#[starknet::contact]
mod Account {

  use array::ArrayTrait;
  use box::BoxTrait;
  use ecdsa::check_ecdsa_signature;
  use starknet::get_caller_address;
  use starknet::get_tx_info;
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

    fn is_valid_signature(self: @ContractState, hash: felt252, signature: Array<felt252>) -> felt252 {
      let is_valid = self.is_valid_signature_bool(hash, signature.span());
      if is_valid { 'VALID' } else { 0 }
    }
  }

  #[external(v0)]
  #[generate_trait]
  impl ProtocolImpl of ProtocolTrait {

    fn __execute__(ref self: ContractState, calls:Array<Call>) -> Array<Span<felt252>> {
      only_protocol();
    }

    fn __validate__(self: @ContractState, calls:Array<Call>) -> felt252 {
      only_protocol();

      let tx_info = get_tx_info().unbox();
      let tx_hash = tx_info.transaction_hash;
      let signature = tx_info.signature;

      let is_valid = self.is_valid_signature_bool(tx_hash, signature);
      assert(is_valid, 'Account: Incorrect tx signature');
      'VALID'

    }

  }

  #[generate_trait]
  impl PrivateImpl of PrivateTrait {

    fn only_protocol(self: @ContractState) {
      let sender = get_caller_address();
      assert(sender.is_zero(), 'Account: invalid caller');
    }

    fn is_valid_signature_bool(self: @ContractState, hash: felt252, signature: Span<felt252>) -> bool
      let is_valid_length = signature.len() == 2_u32;

      if !is_valid_length {
        return false;
      }

      check_ecdsa_signature(hash, self.public_key.read(), *signature.at(0_u32), *signature.at(1_u32))
    }

  }

}
