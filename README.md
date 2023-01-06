<hr/>
<hr/>

<a name="readme-top"></a>

# INPUT CONTROL CONTRACT

<hr/>

# ENSURES YOUR FUNCTIONS ARE ONLY CALLED WITH CERTAIN VALUES AS INPUTS DEPENDING ON THE CALLER
The code in this repo hasn't been tested or improved yet but I think it already gives good idea of what it is. If further elaboration or development please mention me in your work.
😉 https://github.com/CarlosAlegreUr 😉

<hr/>

## 🙀 A PROBLEM THAT SOLVES 🙀

Imagine you have an NFT collection and you have to update a token URI due to some improvement to your
client's NFT.

Making the ""updateURI()"" function only callable by you will force your client to hope and trust that you will call it passing a correct URI.

Using an InputControl you now can make that function
external and let your client call the function with a 
token URI he previously knows points to the correct
data.

And the client can't cheat either because InputControl
uses hash values derived from the inputs' values to check
if the input is what it was agreed to be.
😊

<hr/>

## 🤖 General usecase explanation 🤖

InputControl can be used to control which inputs can some addresses send to your smart contracts functions.

<hr/>

## ✨ How to use ✨

1. To use InputControl make your contract inherit InputControl and add the isAllowedInput()
   modifier in the functions you desire to control their inputs. The '\_input' parameter of the
   modifier must be = keccak256(abi.encodePacked(inputs)).

2. Additionally you can override callAllowInputsFor() if you please mixing this functionality with,
   for example, other useful ones like Owner or AccessControl contracts from OpenZeppelin.

([back to top](#🙀-the-problem-🙀))

<hr/>

## 🎉 FUTURE IMPROVEMENTS 🎉

* Test the code. 
* Improve data types and structure.
* Add deployment script and example of use script.

([back to top](#🙀-the-problem-🙀))

<hr/>

<a name="realcase"></a>

## Contact

Carlos Alegre Urquizú - calegreu@gmail.com

([back to top](#🙀-the-problem-🙀))

<hr/>

## 📜 License 📜

Distributed under the MIT License. See `LICENSE.txt` for more information.

([back to top](#🙀-the-problem-🙀))
