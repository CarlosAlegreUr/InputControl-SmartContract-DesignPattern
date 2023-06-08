<hr/>
<hr/>

<a name="readme-top"></a>

# InputControl Contract

<hr/>

# Ensures your functions are only called with specific inputs' values for each caller

## 💽Testing and implementation example repo => [(click)](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing) 💽

## 💽NPM repo => [(click)](https://www.npmjs.com/package/input-control-contract) 💽

<hr/>

If further elaboration or development please mention me in your work.

😉 https://github.com/CarlosAlegreUr 😉

<hr/>

## 🙀 A PROBLEM THAT SOLVES 🙀

Imagine you have an NFT collection and you have to update a token URI due to some improvement for your
client's NFT.

Making the ""updateURI()"" function only callable by you will force your client to hope and trust that you will call it passing a correct URI.

Using InputControl now you can make that function
external and let your client call the function with a
token URI he previously knows points to the correct
data.

And the client can't cheat either. This is because InputControl
uses hash values derived from the inputs' values to check
if the input is what it was agreed to be.
😊

<hr/>

## 🤖 General usecase explanation 🤖

InputControl can be used to control which inputs can some addresses send to your smart contracts' functions.

Furthermore you can allow your user to call a function with a defined inputs sequence.

Example: You want your client only to call a function 3 times, first time with input value = 1, second value = 2 and third time value = 3. Input control can handle that the desired values are used in the desired order.

<hr/>

## ✨ How to use ✨

1. To use InputControl make your contract inherit InputControl and add the isAllowedInput()
   modifier in the functions you desire to control their inputs. The '\_input' parameter of the
   modifier must be = keccak256(abi.encode(inputs)).
   The parameters of the modifier must be:

   1.1 The Function Selector => bytes4(keccak256(bytes("funcSignatureAsString")))

   1.2 The caller => msg.sender

   1.3 The unique identifier of the input => keccak256(abi.encode(inputs))
   Notice! You must not use abi.encodePacked() because it can give the same output for different inputs
   and the identifier would stop being unique.

2. Additionally you can override callAllowInputsFor() if you please mixing this functionality with,
   for example, other useful ones like Owner or AccessControl contracts from [OpenZeppelin](https://docs.openzeppelin.com/contracts/4.x/access-control).

   Check a simple implemented example at [UseCaseContract.sol](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing/blob/main/contracts/UseCaseContract.sol).

3. If inheriting the contract makes your code too long to deploy use the modular implementation, check how to use
   here => [InputControlModular](https://github.com/CarlosAlegreUr/InputControl-SmartContract-DesignPattern/tree/main/modularVersion)

<hr/>

## 📰 Last Changes 📰

- Added new modular/interface implementation. In some codes inheriting InputControl could make the contract too big to be deployed. Inheriting implementation still available in the package though :D.

- Fixed bug, inputToTimesToUse mapping now is overwritten correctly. In previous version it could overflow and/or lead to unexpected behaviours.

- New tests in tests' repository.

## 🎉 FUTURE IMPROVEMENTS 🎉

- Improve and review code and tests. (static analysis, audit...)

- Test in testnet.
- Create modifier locker. Make it more flexible and be able to activate or deactivate InputControl in your functions.
- Check if worth it to create better option: adding more allowed inputs to client who hasn't used all of them. Now it overwrites.
- Check gas implications of changing 4 bytes function selector to 32 bytes hashed function signatures.

<hr/>

<a name="realcase"></a>

## 📨 Contact 📨

Carlos Alegre Urquizú - calegreu@gmail.com

<hr/>

## ☕ Buy me a CryptoCoffee ☕

Buy me a crypto coffe in ETH, MATIC or BNB ☕🧐☕
(or tokens if you please :p )

0x2365bf29236757bcfD141Fdb5C9318183716d866

<hr/>

## 📜 License 📜

Distributed under the MIT License. See [LICENSE](https://github.com/CarlosAlegreUr/InputControl-SmartContract-DesignPattern/blob/main/LICENSE) in the repository for more information.