<hr/>
<hr/>

<a name="readme-top"></a>

# InputControl Contract

<hr/>

# Ensures your functions are only called with certain values as inputs depending on the caller

## π½Testing and implementation example repo => [(click)](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing) π½

<hr/>

The code in this repo has only been tested in the hardhat local network during 2 afternoons. Should work though. 

Testing and simple implementation repo => [(click)](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing)

If further elaboration or development please mention me in your work.

π https://github.com/CarlosAlegreUr π

<hr/>

## π A PROBLEM THAT SOLVES π

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
π

<hr/>

## π€ General usecase explanation π€

InputControl can be used to control which inputs can some addresses send to your smart contracts' functions.

Furthermore you can allow your user to call a function with a defined inputs sequence.

Example: You want your client only to call a function 3 times, first time with input value = 1, second value = 2 and third time value = 3. Input control can control that the desired values are used in the desired order.

<hr/>

## β¨ How to use β¨

1. To use InputControl make your contract inherit InputControl and add the isAllowedInput()
   modifier in the functions you desire to control their inputs. The '\_input' parameter of the
   modifier must be = keccak256(abi.encodePacked(inputs)).

2. Additionally you can override callAllowInputsFor() if you please mixing this functionality with,
   for example, other useful ones like Owner or AccessControl contracts from [OpenZeppelin](https://docs.openzeppelin.com/contracts/4.x/access-control).

Check a simple implemented example at [UseCaseContract.sol](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing/blob/main/contracts/UseCaseContract.sol).

<hr/>

## π FUTURE IMPROVEMENTS π

- Improve and review code's tests.
- Test in testnet.
- Check for improvements on data types and structure.
- New functionality: control different functions call order.
- Make a function's inputs control interchangeable between
sequence inputs or unordered inputs.

<hr/>

<a name="realcase"></a>

## π¨ Contact π¨

Carlos Alegre UrquizΓΊ - calegreu@gmail.com

<hr/>

## β Buy me a CryptoCoffee β

Buy me a crypto coffe in ETH, MATIC or BNB βπ§β
(or tokens if you please :p )

0x2365bf29236757bcfD141Fdb5C9318183716d866


<hr/>

## π License π

Distributed under the MIT License. See [LICENSE](https://github.com/CarlosAlegreUr/InputControl-SmartContract-DesignPattern/blob/main/LICENSE) in the repository for more information.
