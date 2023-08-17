---
---

<a name="readme-top"></a>

# **InputControl Contract** 📜

---

## _It allows you to specify the order and value of inputs that users can send to your functions. It can be used as global public infrastructure or in a private way._

---

### [💽 **Testing repo with implementation examples**](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing)

### [💽 **NPM repo**](https://www.npmjs.com/package/input-control-contract)

---

## **Index 📌**

- [**General usecase explanation 🤖**](#general-usecase-explanation)
- [**Problems Addressed 🙀**](#a-problem-that-solves)
- [**How to use ✨**](#how-to-use)
- [**Last Changes 📰**](#last-changes)
- [**Contributing 💻**](#contributing)
- [**Contact 📨**](#contact)
- [**Buy me a CryptoCoffee ☕**](#buy-me-a-cryptocoffee)
- [**License MIT 📜**](#license)

---

<a name="general-usecase-explanation"></a>

## 🤖 **General Usecase Explanation** 🤖

**`InputControl`** lets you set the order in which, and the value of, the inputs users can send to your functions.

**Example**: Imagine you want a user to invoke a function thrice—first with an input value of 1, next with 2, and finally, 3. InputControl ensures these values are used in the specified sequence. Alternatively, with the unordered option, users can provide these inputs in any order they prefer.

In broader terms, it grants permissions to users for securely (with consent) calling any function affecting a state you own on the blockchain. It acts as a platform for agreements akin to third-party function calls or consensus-driven functions involving multiple participants.

By merging it with other contracts in development, such as **_`CallOrderControl`_** and **_`InteractionControl`_**, or even using it standalone, **`InputControl`** can be a primary component for public infrastructure. This strategy can speed up development for projects requiring the features of InputControl, as outlined in the **"Problems Addressed 🙀"** section.

---

<a name="a-problem-that-solves"></a>

## **Problems Addressed** 🙀

InputControl addresses several challenges. While the list below mentions 2 of them, more use-cases await discovery. Further work is ongoing on **_`CallOrderControl`_** and **_`InteractionControl`_**, which could revolutionize the orchestration of complex contract interactions involving multiple parties. Still, the focus has primarily been on InputControl since I couldn't think of real use-cases for the other Control contracts. Explore them here:

- [**CallOrderControl Repo**](https://github.com/CarlosAlegreUr/CallOrderControl-SmartContract-DesignPattern/tree/main)
- [**InteractionControl Repo**](https://github.com/CarlosAlegreUr/InteractionControl-SmartContract)

1. **Decentralized Matchmaking**:
   Imagine a decentralized gaming platform where players wager and compete. Guaranteeing both parties initiate the match and secure funds can be intricate. InputControl can manage the complexities of any game logic agreement.

2. **Decentralized NFT Upgrades**:
   Envision an NFT collection requiring a token URI update. Exclusively allowing the _`updateURI()`_ function to be callable by you might strain trust with your client. With InputControl, you can externalize the function, letting the client call it with a known, correct token URI—promoting transparency without sacrificing integrity. Imagine a NFT game implements upgrades but doesn't want the backend to handle them in a centralized way. It enables the user to do it without any user making their NFT overpowered by faking a superior upgrade. The InputControl contract would make that possible.

---

<a name="how-to-use"></a>

## **How to use** ✨

InputControl's versatility comes in different implementations tailored for particular use-cases:

- **InputControl by Inheritance (ICI)**: Best for single contracts.
- **InputControl by Composition (ICC)**: Perfect for private systems with multiple contracts, especially when a single contract's code results in a "too big to be deployed" error.
- **InputControl by Public (ICP)**: A global contract for public use. With intentions to launch across many EVM-compatible blockchains, it provides decentralized input control management for any interested contract.

### **How to use IC from your contracts** 🧑‍🔧

- **ICI** Example: [UseCaseContract.sol](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing/blob/main/contracts/owned/inheritanceVersion/UseCaseContract.sol)
- **ICC** Example: [UseCaseContractComposite.sol](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing/blob/main/contracts/owned/compositeVersion/UseCaseContractComposite.sol)
- **ICP** Example: [UseCaseContractPublic.sol](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing/blob/main/contracts/public/UseCaseContractPublic.sol)

---

<a name="last-changes"></a>

## Last Changes 📰

- 🔄 All code has been **refactored**: Admin based (centralized) or non-admin based (decentralized public infrastructure) versions.

---

<a name="contributing"></a>

## **Contributing** 💻

Open issues or PRs in the [testing repo](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing).

If further independent development occurs, a [mention of me](https://github.com/CarlosAlegreUr) in your work would be much appreciated 😄

---

<a name="contact"></a>

## **Contact** 📨

Carlos Alegre Urquizú - calegreu@gmail.com

---

<a name="buy-me-a-crytocoffee"></a>

## **Buy me a CryptoCoffee** ☕

Support me with ETH, MATIC, BNB, or any token of your choice ☕🧐☕

`0x2365bf29236757bcfD141Fdb5C9318183716d866`

---

<a name="license"></a>

## **License** 📜

Distributed under the MIT License. View [LICENSE](https://github.com/CarlosAlegreUr/InputControl-SmartContract-DesignPattern/blob/main/LICENSE) in the repository for further details.
