<hr/>
<hr/>

<a name="readme-top"></a>

# INDEPENDENT FUNDS MANAGER (IFM)

<hr/>

# SMART CONTRACT'S DESIGN PATTERN TO ENSURE YOUR FUNDS ARE USED IN THE WAY THEY PROMISED

The code in this repo hasn't been tested yet but I think it already gives good idea of what it is. If further elaboration or development please mention me in your work. 
😉 https://github.com/CarlosAlegreUr 😉

(need to add extra mapping that maps function sgnatures to permission number... TODO)


<hr>

## 🙀 THE PROBLEM 🙀

Imagine you have a service programmed in some smart contracts. It's designed in such a way that only you and your team have the addresses with access to certain functions.

Now imagine that those contract functions are meant to be used by, or manage; some clients' funds.

In that business schema, how can your clients be sure that once they send funds to any address that can call those functions, those funds will actually be used for calling the functions? How can they be sure you will never take any of the funds, run away with them or use them in any different way?

IFM contracts design pattern allows the client to be 100% sure those bad scenaios will never happen. If coded correctly of course. 😉

<hr/>

## 🤖 General usecase explanation 🤖

IFM can be used to grant permission to any address or addresses on how and how much of some third party address' funds to spend in their smart contracts' functions.

[Click here to see real use cases](#😎-real-use-cases-😎)

<hr/>

## ✨ How it works (how to use as a client) ✨

- You send your funds to an IFM. (can be withdrawn at any time only by you)

Inside the contract your funds have 2 properties only you can modify:

- Frozen or not.
- Quantity allowed to spend in a function.

To allow the use of your funds you call 2 functions:
setFrozen() && givePermission(). They will:

1. Unfrozen your funds.
2. Give permision for specific quantity of funds to be spend in a function.

Then the "bakcend" code of the business will be able to call the IFM contrat that will call the contract where their services are and execute them. Only business addresses can call the functions in an IFM. Except the 2 functions mentioned above that controll your own funds and it's state.

After all that, the IFM contract always frozens your funds again and emits an event with useful information on how the transaction went.

Once deployed the IFM contract can't be modified by anyone.

([back to top](#🙀-the-problem-🙀)) 

<hr/>

## 💻 How to implement (as a developer) 🐱‍💻

1. You must import the IFM contract and declare it as a variable in your contracts' storages.

2. Initialize the variable in the constructor.

3. And add the onlyIFM modifier to all functions you want to control with it.

4. In the IFM code, add the enums needed according to how many functions you need.

5. Add extra parameters to the
   IFM\_\_UsefulInfoInFunctionCall() event if you need.

6. Implement the [OpenZeppelin](https://www.openzeppelin.com/) AccessControl for your team if you want. (you may need to add more callFunction() functions)

([back to top](#🙀-the-problem-🙀)) 

<hr/>

## Pros and cons of using IFM design

- PROS

  - Client side: guarantees no corrupted used of your funds.
  - Business side: you gain client's confidence.

- CONS
  - Client side: you pay gas fees unfrozing your funds and giving permissions.
  - Business side: More complex code, not super easy to implement.

([back to top](#🙀-the-problem-🙀)) 

<hr/>

## 🎉 FUTURE IMPROVEMENTS 🎉

- Allow ERC20 tokens management.
- Enable permission for multiple functions at the same time.

([back to top](#🙀-the-problem-🙀)) 

<hr>

<a name="realcase"></a>

## 😎 Real use cases 😎

1. Imagine a smart contract based bank services business. They can apply IFM to their contracts
   in order to be able to use your funds when executing their services but only if you agreed on using them for that specific function and with a specific quaintity. Maybe taking a loan or whatever financial action you want to carry out.

2. Imagine an NFT collection that needs to change their token URIs in order to reward a costumer (for any reason)
   with an increase of rarity on their NFT. You as a client may send the funds that cost to the address that can
   call the \_setTokenURI() function in a contract and hope your funds will be used for that. Now you just have to
   send them to an IFM contract and grant access for that specific operation.

([back to top](#🙀-the-problem-🙀)) 

<hr>

## Contact

Carlos Alegre Urquizú - calegreu@gmail.com

([back to top](#🙀-the-problem-🙀)) 

<hr/>

## 📜 License 📜

Distributed under the MIT License. See `LICENSE.txt` for more information.

([back to top](#🙀-the-problem-🙀)) 