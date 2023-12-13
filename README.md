<div align="center">
<img alt="starknet logo" src="https://github.com/ccolorado/talk_account_abstraction_en_starknet_seedlatam-/blob/main/images/workshop_4.png" width="800" >
  <h1 style="font-size: larger;">
  <strong> Workshop de Cero a Héroe:</strong>
   <br/>
  <strong> SEED Latam-Layer 2 en Español-StarknetEs </strong> 

  </h1>
    <img src="https://github.com/ccolorado/talk_account_abstraction_en_starknet_seedlatam-/blob/main/images/SEED.png" width="40">
    <img src="https://github.com/ccolorado/talk_account_abstraction_en_starknet_seedlatam-/blob/main/images/Layer2.png" width="40">
    <img src="https://github.com/ccolorado/talk_account_abstraction_en_starknet_seedlatam-/blob/main/images/StarknetEs.png" width="40">
    <br/><br/>


<a href="https://www.youtube.com/live/xw9zuXyrStE?si=4QtHcuT7qb399JLX">
<img src="https://img.shields.io/badge/Workshop L2: 1ª Clase-Youtube-red?logo=youtube"/>
</a>
<a href="https://www.youtube.com/watch?v=RG3pYw18CPo&t=9s">
<img src="https://img.shields.io/badge/Workshop L2: 2ª Clase-Youtube-red?logo=youtube"/>
</a>
<a href="https://www.youtube.com/live/dgV34Pkvm5o?si=X342hdTOCzeCWwaM">
<img src="https://img.shields.io/badge/Workshop L2: 3ª Clase-Youtube-red?logo=youtube"/>
</a>
<a href="https://www.youtube.com/live/_J_3tqv3x5w?si=IEfBomm2_gShWUZv">
<img src="https://img.shields.io/badge/Workshop L2: 4ª Clase-Youtube-red?logo=youtube"/>
</a>
    <br/><br/>
</a>
<a href="https://twitter.com/SEEDLatam">
<img src="https://img.shields.io/twitter/follow/SEED Latam?style=social"/>
</a>
<a href="https://twitter.com/Layer2es">
<img src="https://img.shields.io/twitter/follow/Layer 2 en Español?style=social"/>
</a>
<a href="https://twitter.com/StarkNetEs">
<img src="https://img.shields.io/twitter/follow/StarknetEs?style=social"/>
</a>
    <br/><br/>
<a href="https://github.com/Layer2es">
<img src="https://img.shields.io/badge/Layer2 Es-Github-blue"
/>
<a href="https://github.com/Starknet-Es">
<img src="https://img.shields.io/badge/Starknet Es-Github-yellow"
/>
<a href="https://github.com/Layer2es/Workshop-Mensajes-Ethereum-Starknet">
<img src="https://img.shields.io/github/stars/Layer2es/Workshop-Mensajes-Ethereum-Starknet?style=social"/>
</a>

</div>

# Why and how Account Abstraction is important.
* Signature Automation is not something blockchain tech do naturally.
* Browsers can do a bunch of things, but they are limited, one thing that they can't  sign transactions.
  That's why wallets are an add-on

Use cases
* Payment atomization
* Signing efficiency (games)
* Alternative 'login' options (biometric id) 
* Automatic payments
* account delegation, (dead man switch, testaments)


# What is needed

# How is it done ...
Programmatically ?
   * eip-165
   * SNIP-5
   * SNIP-6

# Account abstraction Interface
```cairo
struct Call {
    to: ContractAddress,
    selector: felt252,
    calldata: Array<felt252>
}

trait ISRC6 {
    fn __execute__(calls: Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(calls: Array<Call>) -> felt252;
    fn is_valid_signature(hash: felt252, signature: Array<felt252>) -> felt252;
}

trait ISRC5 {
    fn supports_interface(interface_id: felt252) -> bool;
}

trait IAccountAddon {
    fn __validate_declare__(class_hash: felt252) -> felt252;
    fn __validate_deploy__(class_hash: felt252, salt: felt252, public_key: felt252) -> felt252;
    fn public_key() -> felt252;
}

```

_Externally Owned accounts_ are not present on Starknet

 *There are restrictions on what you can do inside the __validate__ method to protect the Sequen cer against Denial of Service (DoS) attacks [3].* 

# Transaction anatomy:
   Target SmartContract:
   Function Selector:
   Argument(s) payload:

# Transaction's life cycle:
1. A transaction is queued
2. A transaction is validated
3. One or multiple  transactions are executed
4. Return message(es) are serialized as felts

# Basic Usage:
* Signing strings (transactions)
* Starknet delegate call

1. Execute and Validate
   These methods *are meant to be executed by the starknet protocol*, but are public for everyone.
   `__validate__`: Will check that the signature of a transaction is valid, not that the `tx` will pass.
   This method returns a _short string_ `VALID` rather than a boolean value
   * Some Restrictions apply, to protect the sequencer of a DoS attacks.
   [Starknet Docs: Limitations on the validate function](https://docs.starknet.io/documentation/architecture_and_concepts/Accounts/validate_and_execute/#validate_limitations)

`__execute__`:
   Return types A serialized span of felts will be returned by the starknet protocol.

`is_valid_signature`: Is not part of the protocol but a helper artefact for error management.
`supports_interface`: TODO: Review why this SNIP-5 requirement implies that it adheres to the SNIP-6

`__validate_declare__`: SNIP-6 is enough to guarantee that a smart contract is in fact an account contract,


# Enhanced Account Abstraction Interface

```cairo
/// @title IAccount Additional account contract interface
trait IAccountAddon {
   /// @notice Assert whether a declare transaction is valid to be executed
   /// @param class_hash The class hash of the smart contract to be declared
   /// @return The string 'VALID' represented as felt when is valid
   fn validate_declare(class_hash: felt252) -> felt252;

   /// @notice Assert whether counterfactual deployment is valid to be executed
   /// @param class_hash The class hash of the account contract to be deployed
   /// @param salt Account address randomizer
   /// @param public_key The public key of the account signer
   /// @return The string 'VALID' represented as felt when is valid
   fn validate_deploy(class_hash: felt252, salt: felt252, public_key: felt2 52) -> felt252;

   /// @notice Exposes the signer's public key
   /// @return The public key
   fn public_key() -> felt252;
}
```

# Deployments

_Counterfactual deployment_: Mechanism to deploy an account contract without relying on another account_contract to pay
for the related gas fee.

# Transactions:

## Function Selector
Its the `starknet_keccak` of the function name (ASCII encoded) n the format:
```cairo
fn_name(param1_type,param2_type,...)->output_type
```
*IMPORTANT NOTICE:* Spaces are taken out from definitions

### Special Types
Complex types like `u256`, `Tuples`, `Structs`, and `Enums` are broken down into their primitives.
e.g. `u256` -> `(u128, u128)`



| Structure | Item Name | Signature pattern                                |
| --------- | --------- | ------------------------------------------------ |
| Tuples    | elements  | `(el1_type,el2_type,el3_type,...,elN_type)`      |
| Structs   | fields    | `(F1_type,F2_type,F3_type,...,FN_type)`          |
| Enums     | variants  | `E(Var1_type,Var2_type,Var3_type,...,VarN_type)` |

*IMPORTANT NOTICE:* Enums require a leading `E` to avoid collisions between tuples or structs
Example:

```cairo
#[derive(Drop, Serde)]
enum MyEnum {
    FirstVariant: (felt252, u256),
    SecondVariant: Array<u128>,
}

#[derive(Drop, Serde)]
struct MyStruct {
    field1: MyEnum,
    field2: felt252,
}

fn foo(param1: @MyEnum, param2: MyStruct) -> bool; 
```

The signature is:

```cairo
  foo(@E((felt252,(u128,u128)),Array<u128>),(E((felt252,(u128,u128)),Array<u128>),felt252))->E((),())
/* ^  ^^  ^                    ^            ^^                                    ^          ^
   1  23  4                    5            67                                    8          9

1: Function Name
2: Parameter 1 (P1) / ***
3: P1: MyEnum -> Enumerator leading E
4: P1: MyEnum -> Variant 1
5: P1: MyEnum -> Variant 2
6: Parameter 2 (P2)
7: P2: Field 1 -> MyEnum with leading E
8: P2: Field 2 -> felt252
9: Return type (Boolean enum)
*/
```

### How Interfaces are Identified

```cairo
trait IAccount {
    fn supports_interface(felt252) -> bool;
    fn is_valid_signature(felt252, Array<felt252>) -> bool;
    fn __execute__(Array<Call>) -> Array<Span<felt252>>;
    fn __validate__(Array<Call>) -> felt252;
    fn __validate_declare__(felt252) -> felt252;
}

```python


from starkware.starknet.public.abi import starknet_keccak

extended_function_selector_signatures_list = [
    'supports_interface(felt252)->E((),())',
    'is_valid_signature(felt252,Array<felt252>)->E((),())',
    '__execute__(Array<(ContractAddress,felt252,Array<felt252>)>)->Array<(@Array<felt252>)>',
    '__validate__(Array<(ContractAddress,felt252,Array<felt252>)>)->felt252',
    '__validate_declare__(felt252)->felt252'
]


def main():
    interface_id = 0x0
    for function_signature in extended_function_selector_signatures_list:
        function_id = starknet_keccak(function_signature.encode())
        interface_id ^= function_id
    print('IAccount ID:')
    print(hex(interface_id))



signature = 0x0
signature ^= starknet_keccack(extended_function_selector_signatures_list[0].encode())
signature ^= starknet_keccack(extended_function_selector_signatures_list[1].encode())
//         ...
signature ^= starknet_keccack(extended_function_selector_signatures_list[N].encode())

hex(signature)

if __name__ == "__main__":
    main()


def main():
    interface_id = 0x0
    for function_signature in extended_function_selector_signatures_list:
    function_id = starknet_keccak(function_signature.encode())
    interface_id ^= function_id
    print('IAccount ID:')
    print(hex(interface_id))


```



# Practice

## Setup

1. Create Project
scarb new aa

2. Set up environment for Smart Contract development (instead of just code)
```toml
// aa/Scarb.toml

[dependencies]
starkent = "2.2.0"

[[target.starknet-contract]]
```

3. Turn the sample script/code into a starknet contract

```cairo
#[starknet::contract]
mod Account {

   #[storage]
   struct Storage {
      public_key: felt252
   }
}
```





