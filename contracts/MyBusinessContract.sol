// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error MyBusinessContract__OnlyIFMCanCallThisContract();

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "./InputControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Example of contract using InputControl.
 * @author Carlos Alegre Urquizú (GitHub --> https://github.com/CarlosAlegreUr)
 *
 * @dev To use InputControl make your contract inherit InputControl and add the isAllowedInput()
 * modifier in the functions you desire to control their inputs. Add to them an extra parameter,
 * this parameter should be a 32 bytes hash representation of the other function allowed inputs
 * given by the contract owner in some front-end back-end communication.
 *
 * @dev Additionally you can override callAllowInputsFor() if you please mixing this functionality with,
 * for example, other useful ones like Owner or AccessControl contracts from OpenZeppelin.
 */
contract MyBusinessContract is InputControl, Ownable {
    uint256 private s_incrediblyAmazingNumber;

    function myFunc(
        uint256 _newNumber,
        bytes32 _input
    ) external isAllowedInput("myFunc", msg.sender, _input) {
        s_incrediblyAmazingNumber = _newNumber;
    }

    function callAllowInputsFor(
        address _client,
        bytes32[] calldata _validInputs,
        string calldata _funcSignature
    ) public override onlyOwner {
        allowInputsFor(_client, _validInputs, _funcSignature);
    }
}
