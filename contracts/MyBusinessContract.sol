// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

error MyBusinessContract__OnlyIFMCanCallThisContract();

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "./IndependentFundsManager.sol";

/**
 * @title Example of contract using IndependentFundsManager (IFM).
 * @author Carlos Alegre Urquizú (GitHub --> https://github.com/CarlosAlegreUr)
 *
 * @dev To use IFM you must import it and declare the IFM contract as a variable in your storage.
 * Initialize it in de constructor.
 * And add the onlyIFM modifier to all function you want to control with it.
 */
contract MyBusinessContract {
    address immutable i_ifmAddress;
    IndependentFundsManager immutable i_independentFundsManager; // MUST ADD

    uint256 private s_incrediblyAmazingNumber; // YOUR STUFF

    // MUST ADD
    constructor(address payable _independentFundsManagerAddress) {
        i_ifmAddress = _independentFundsManagerAddress;
        i_independentFundsManager = IndependentFundsManager(
            _independentFundsManagerAddress
        );
    }

    // MUST ADD
    modifier onlyIFM() {
        if (msg.sender != i_ifmAddress) {
            revert MyBusinessContract__OnlyIFMCanCallThisContract();
        }
        _;
    }

    // YOUR STUFF + onlyIFM
    function changeNumber(uint256 _newNumber) private onlyIFM {
        s_incrediblyAmazingNumber = _newNumber;
    }
}
