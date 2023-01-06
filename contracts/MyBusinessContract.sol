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
 * modifier in the functions you desire to control their inputs. The '_input' parameter of the
 * modifier must be = keccak256(abi.encodePacked(inputs)).
 *
 * @dev Additionally you can override callAllowInputsFor() if you please mixing this functionality with,
 * for example, other useful ones like Owner or AccessControl contracts from OpenZeppelin.
 */
contract MyBusinessContract is InputControl, Ownable {
    uint256 private s_incrediblyAmazingNumber;
    address private s_someAddress;

    function myFunc(
        uint256 _newNumber,
        address _anAddress
    ) external isAllowedInput("myFunc", msg.sender, keccak256(abi.encodePacked(_newNumber, _anAddress))) {
        s_incrediblyAmazingNumber = _newNumber;
        s_someAddress = _anAddress;
    }

    function callAllowInputsFor(
        address _client,
        bytes32[] calldata _validInputs,
        string calldata _funcSignature
    ) public override onlyOwner {
        allowInputsFor(_client, _validInputs, _funcSignature);
    }
}
