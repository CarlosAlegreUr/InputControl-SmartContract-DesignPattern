<hr/>
<hr/>

<a name="readme-top"></a>

# 📜 InputControl Contract 📜

<hr/>

# Ensures your functions are only called with specific inputs' values for each caller

## 💽Testing repo with implementation examples => [(click)](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing) 💽

## 💽NPM repo => [(click)](https://www.npmjs.com/package/input-control-contract) 💽

<hr/>

## Index 📌

- [General usecase explanation 🤖](#general-usecase-explanation)
- [PROBLEMS THAT SOLVE 🙀](#a-problem-that-solves)
- [How to use ✨](#how-to-use)
- [Last Changes 📰](#last-changes)
- [FUTURE IMPROVEMENTS 🎉](#future-improvements)
- [Contributing 💻](#contributing)
- [Contact 📨](#contact)
- [Buy me a CryptoCoffee ☕](#buy-me-a-cryptocoffee)
- [License MIT 📜](#license)

<hr/>

<a name="a-problem-that-solves"></a>

## 🤖 General Usecase Explanation 🤖

**InputControl** offers a dynamic way to manage the inputs that specific addresses can send to your smart contracts' functions. This tool is not only restricted to ordered sequences. Inputs can also be set in a way that allows them to be called in any unordered fashion, adding flexibility to the contract interactions.

Notably, it empowers you to dictate a sequence for your users when calling functions.

**Example**: Imagine you want a user to invoke a function thrice—first with an input value of 1, next with 2, and finally, 3. InputControl ensures these values are used in the specified sequence. Alternatively, with the unordered option, users can provide these inputs in any order they prefer.

In broader terms, it grants permissions to users to modify any function affecting a state you manage on the blockchain. Essentially, it provides a platform for agreements similar to third-party function calls or consensus-driven functions involving multiple participants.

Combined  with other contracts under development, like **CallOrderControl** and **InteractionControl**, (or just on its own) **InputControl** has the potential to serve as a cornerstone for public infrastructure. This foundational approach can speed up the development process for projects that necessitate the  InputControl's features, as highlighted in the **"🙀 Problems Addressed 🙀"** section.

---

<a name="a-problem-that-solves"></a>

## 🙀 Problems Addressed 🙀

InputControl tackles a variety of challenges. While the list below encompasses several, there might be more use-cases awaiting discovery. Moreover, efforts are underway on **CallOrderControl** and **InteractionControl**—potentially revolutionary for orchestrating intricate contract interactions involving multiple parties. However, the focus has predominantly been on InputControl for now because I couldn't thinkg of real use-cases for the other Control contracts. Explore these concepts here:

- [CallOrderControl Repository](https://github.com/CarlosAlegreUr/CallOrderControl-SmartContract-DesignPattern/tree/main)
- [InteractionControl Repository](https://github.com/CarlosAlegreUr/InteractionControl-SmartContract)

**1. Decentralized Matchmaking**:
Imagine a decentralized gaming platform where players bet and compete. Ensuring both parties initialize the match and secure funds can be challenging. InputControl can navigate the intricacies of any game logic agreement.

**2. Decentralized NFT Upgrades**:
Consider an NFT collection that needs a token URI update. Having the "updateURI()" function exclusively callable by you could strain trust with your client. But with InputControl, you can externalize the function, allowing the client to call it with a known, correct token URI—ensuring transparency without compromising integrity. Imagine a NFT game implmenets upgrades but doesnt want the backend to handle them in a centralized manner and lets the user do it but without any user making their nft overpowered faking a better upgrade.

---

<a name="how-to-use"></a>

## ✨ Usage Guidelines ✨

InputControl's flexibility comes in various implementations tailored to specific use-cases:

- **InputControl by Inheritance (ICI)**: Suitable for single contracts.
- **InputControl by Composition (ICC)**: Ideal for private systems, encompassing multiple contracts. It's especially handy when a single contract's code size precludes the use of the inheritance version.

- **InputControl by Public (ICP)**: A universal contract available for public use. With plans to deploy across numerous EVM-compatible blockchains, it offers input control management for any interested contract.

### How to use IC from your contracts 🧑‍🔧

<details>  <summary>  ICI </summary>

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

</details>
<details>  <summary>  ICC </summary> </details>
<details>  <summary>  ICP </summary> </details>

<hr/>

<a name="future-improvements"></a>

## 🎉 FUTURE IMPROVEMENTS 🎉

- Improve and review code and tests. (static analysis, audit...)

- Test in testnet.
- Create modifier locker. Make it more flexible and be able to activate or deactivate InputControl in your functions.
- Check if worth it to create better option: adding more allowed inputs to client who hasn't used all of them. Now it overwrites.
- Check gas implications of changing 4 bytes function selector to 32 bytes hashed function signatures.

<hr/>

<a name="contributing"></a>

## Contributing 💻

Im learning how to use PRs, feel free to open issues or PRs.
And, if independent further development, please mention me in your work 😄
😉 https://github.com/CarlosAlegreUr 😉

<hr/>

<a name="contact"></a>

## 📨 Contact 📨

Carlos Alegre Urquizú - calegreu@gmail.com

<hr/>

<a name="buy-me-a-crytocoffee"></a>

## ☕ Buy me a CryptoCoffee ☕

Buy me a crypto coffe in ETH, MATIC or BNB ☕🧐☕
(or tokens if you please :p )

0x2365bf29236757bcfD141Fdb5C9318183716d866

<hr/>

<a name="license"></a>

## 📜 License 📜

Distributed under the MIT License. See [LICENSE](https://github.com/CarlosAlegreUr/InputControl-SmartContract-DesignPattern/blob/main/LICENSE) in the repository for more information.
