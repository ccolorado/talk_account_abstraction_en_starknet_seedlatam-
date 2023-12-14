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

# Cual es la importancia de Abstracción de Cuentas.

* El automatizado de firmas no es algo a lo que se presten las tecnologías blockchain
* Los navegadores tiene que usar wallets a manera de extensiones para poder gestionar
  firmas.
* Si no hay algún tipo de estándar los navegadores nunca adoptaran un estándar como tal.

# Casos de uso:
* Automatización de pagos (subscripciones)
* Manejo de Sesiones.
* Automatización Multifactor (biométricos)
* Delegación de cuestas, (testamentos)
* Recuperación social

# Especificaciones disponibles
   * `eip-165`
   * `SNIP-5`
   * `SNIP-6`

# Interfase de Contrato de Abstracción de cuentas.
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

Tengamos en cuenta que las _Externally Owned accounts_ (EOA's) no figuran en la blockchain
de Starknet de la misma manera que en la de ethereum

*Como la funcion __validate__ va ir directamente al sequencer, su uso debe estar limitado,
para evitar crear un vector de ataque de denegacion de servicio (DoS)* 

# Anatomía de una transacción:
   Smart Contract Destino
   Selector de funcion
   Argumento(s)

# Ciclo de vida de una transacción.
1. Una transacción se forma en la linea.
2. Es validada.
3. Se ejecuta sola o con multiples transacciones.
4. Regresa o no valores de retorno serial izados en felts.

# Uso Basico:
1 Firmado de transacción.

1. Validación y ejecución.

   `__validate__`:  Validara la firma de las transacciones como validas en cuanto a
   autorización, si la tasación tiene algún defecto esto no sera discernido aquí. 
   Regresa el `string` corto `'VALID'` en lugar de un valor booleano.
   _IMPORTANTE_: Estos métodos están diseñados para ser ejecutados por el protocolo y no
       necesariamente nosotros los usuarios.

   Mayor información sobre las limitaciones de la función `__validate__` en la  [documentación
   oficial de Starknet](https://docs.starknet.io/documentation/architecture_and_concepts/Accounts/validate_and_execute/#validate_limitations)
   
2.  `__execute__`:
   Regresa un arreglo de `span` serializado de felts 

3. `is_valid_signature`: Aunque no es usada por el protocolo resulta una función lo
   suficientemente útil para el la integración de los contratos Abstracción de cuentas que
   termino siendo parte del `SNIP-6`.

4. `supports_interface`: Función que permite probar si un contrato tiene implementada una
   interfaz.

# Interfase de Abstracción de cuentas aumentada:

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
Estas funciones aunque no son parte del estándar son útiles para la gestión de contratos
de Abstracción de Cuentas. Lo cual no es necesariamente relevante para usuarios finales,
pero si para desarrolladores. (_Counterfactual deployment_)

# Transacciones:

## Selector de funciones
Un selector de funciones es derivado del el nombre, argumentos y valor de retorno de una
función ( también conocido como firma de función ) y hasheado con la función de que
keccak.

Es *importante notar:* que todos los espacios son removidos de la forma de función. 
```cairo
fn_name(param1_type,param2_type,...)->output_type
```

### Tipos de datos compuestos.
Los tipos de datos compuestos como, `u256`, `Tuples`, `Structs`, and `Enums` son
especificados de manera mas granular
e.g. `u256` -> `(u128, u128)`



| Estructura | Nombre del elemento | Formato de firma                                 |
| ---------  | ---------           | ------------------------------------------------ |
| Tuples     | elementos           | `(el1_type,el2_type,el3_type,...,elN_type)`      |
| Structs    | campos              | `(F1_type,F2_type,F3_type,...,FN_type)`          |
| Enums      | variantes           | `E(Var1_type,Var2_type,Var3_type,...,VarN_type)` |

Es *importante notar:* Que la firma de los `Enums` require una `E` al principio para evitar colisiones con las otras estructuras.

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

La firma seria

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

# Practica

## Inicio

https://github.com/starknet-edu/aa-workshop

1. Crear proyecto
`scarb new aa`

2. Configurar scarb con compatibilidad de smart contacts.
```toml
# aa/Scarb

[dependencies]
starkent = "2.2.0"

[[target.starknet-contract]]
```

3. Turn the sample script/code into a starknet contract

```cairo
// aa/src/account.cairo
#[starknet::contract]
mod Account {

   #[storage]
   struct Storage {
      public_key: felt252
   }
}
```
