# Interface/Modular Implementation

## ✨ How to use ✨

1. Deploy in your network the InputControlModular.sol contract.

2. If desired grant admin role to other contract using setAdmin() with
   the deployer address which is by default the admin address.

<hr/>

## ✨ Notice & How to integrate with AccessControl or Ownable by OpenZeppelin ✨

If implementing yourself the Interface make sure to implement a modifier that controls
the acces to allowInputsFor(). For that in this implementation I've built a simple admin
creaton and management code where the deployer address becomes the admin. And admin is
the only one who can pass the admin role to other address.

I think this option is better because it makes InputControlModular decoupled from other packages,
so to better implement in a decoupled way AccessControl or Ownable from OpenZeppelin wiht InputControlModular check
the UseCaseContract link just down below:

[UseCaseContractModular.sol](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing/blob/main/contracts/modularVersion/UseCaseContractModular.sol)
