// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/* Customed Errors */
error IFM__CallingNotAllowedContract();
error IFM__WithdrawalFailed();
error IFM__NoFundsFound();
error IFM__NotEnoughFunds();
error IFM__ClientFundsAreFrozen();
error IFM__ClientPermissionDenied();
error IFM__FunctionCallFailed();

error IFM_ContratsOnceSetNeverChange();
error IFM__WeDontWantItTakeItBackSmileFace();

// Uncomment this line to use console.log
// import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title Independent Funds Manager (IFM).
 * @author Carlos Alegre Urquizú (GitHub --> https://github.com/CarlosAlegreUr)
 *
 * @notice IFM can be used to grant permission to any address or addresses on how
 * and how much of some third party address' funds to spend in their smart contracts'
 * functions.
 *
 * @dev Use OpenZeppelin contracts to control the access to functions from addresses
 * that belong to your dev team.
 *
 * @dev Plan to accept management of ERC20 tokens in the future.
 * @dev Plan to allow users to give permission to multiple functions at the same time.
 */
contract IndependentFundsManager is Ownable, AccessControl {
    /* Types */
    // Add as much as you need.
    enum PermissionsToCall {
        none, // enum value => 0
        func1, // 1
        func2, // 2
        func3 // 3
        // ...
    }

    /* State Variables */

    address[] private s_yourContracts;
    bool private s_contractsLocked;
    mapping(address => uint256) private s_contractToIndex;

    mapping(address => uint) private s_addressToFunds;
    mapping(address => mapping(PermissionsToCall => uint256))
        private s_addressToSpendPermission;
    mapping(address => bool) private s_addressToFrozen;

    /* Events */
    // Add as much data emitted by event as you need.
    event IFM__UsefulInfoInFunctionCall(bytes functionCalled);

    /* Modifiers */

    modifier checkPermissions(
        address _clientAddress,
        PermissionsToCall _permission,
        uint256 _price,
        address _contractToCall
    ) {
        if (s_contractToIndex[_contractToCall] == 0) {
            revert IFM__CallingNotAllowedContract();
        }
        if (s_addressToFunds[_clientAddress] == 0) {
            revert IFM__NoFundsFound();
        }
        if (s_addressToFunds[_clientAddress] < _price) {
            revert IFM__NotEnoughFunds();
        }
        if (s_addressToFrozen[_clientAddress] == true) {
            revert IFM__ClientFundsAreFrozen();
        }
        if (s_addressToSpendPermission[_clientAddress][_permission] == 0) {
            revert IFM__ClientPermissionDenied();
        }
        _;
    }

    modifier spendFunds(address _clientAddress, uint256 _price) {
        s_addressToFunds[_clientAddress] -= _price;
        _;
    }

    modifier frozenAndDenyPermissionAfter(
        address _clientAddress,
        PermissionsToCall _permission
    ) {
        _;
        s_addressToSpendPermission[_clientAddress][_permission] = 0;
        s_addressToFrozen[_clientAddress] = true;
    }

    /* Functions */

    /**
     * @dev Unlocks the use of setYourContracts() function.
     */
    constructor() {
        s_contractsLocked = false;
    }

    /**
     * @notice IFM doesn't want any extra monet thanks. The
     * receive() and fallback() functions return the money recieved
     * to the caller. Incorrect calls won't be that expensive.
     */
    receive() external payable {
        (bool success, ) = payable(msg.sender).call{value: msg.value}("");
        if (!success) {
            revert IFM__WeDontWantItTakeItBackSmileFace();
        }
    }

    fallback() external payable {
        (bool success, ) = payable(msg.sender).call{value: msg.value}("");
        if (!success) {
            revert IFM__WeDontWantItTakeItBackSmileFace();
        }
    }

    /* External functions */

    /**
     * @dev Initializes the contracts array once and locks the access
     * to it for ever and for everyone.
     *
     * @param _yourContracts all your contracts' addresses that have function
     * you want to implement through IFM.
     */
    function setYourContracts(
        address[] calldata _yourContracts
    ) external onlyOwner {
        if (s_contractsLocked) {
            revert IFM_ContratsOnceSetNeverChange();
        }

        // No valid contract has to be index 0.
        //
        // Because if calling contract not registered, the modifier checkPermissions()
        // checks for the 0 index value to determine if the contract is valid.
        //
        // Therefore if any contract points to 0 that means is invalid.
        //
        // So if we put a valid contract in the position 0, checkPermissions()
        // would consider it invalid when it would be valid.
        for (uint256 i = 0; i < _yourContracts.length; i++) {
            s_contractToIndex[_yourContracts[i]] = i + 1;
        }

        // As no contract can have index 0, offset +1.
        for (uint256 i = 0; i < _yourContracts.length; i++) {
            s_yourContracts[i + 1] = _yourContracts[i];
        }
        s_contractsLocked = true;
    }

    /**
     * @dev Call this function to fund an address on the contract.
     *
     * @notice Call this function to send your funds to the contract.
     */
    function fund() external payable {
        s_addressToFunds[msg.sender] += msg.value;
    }

    /**
     * @notice Call this function to withdraw an amount of your funds from the contract.
     */
    function withdraw(uint256 _quantity) external payable {
        if (s_addressToFunds[msg.sender] < _quantity) {
            revert IFM__NotEnoughFunds();
        }
        (bool success, ) = payable(msg.sender).call{value: _quantity}("");
        if (!success) {
            revert IFM__WithdrawalFailed();
        }
        s_addressToFunds[msg.sender] -= _quantity;
    }

    /**
     * @param _frozen if true caller frozens it's funds. If false, they unfrozen.
     *
     * @notice Call this function to frozen or unfrozen your funds.
     */
    function setFrozen(bool _frozen) external {
        s_addressToFrozen[msg.sender] = _frozen;
    }

    /**
     * @param _permission Enum, check which function maps below or above in this code.
     *
     * @notice Call this function to allow the business to use your funds to call some function.
     * Permissions --> Function list:
     *
     *  none,  // value => 0
     *  func1, // 1
     *  func2, // 2
     *  func3 // 3
     */
    function givePermission(
        PermissionsToCall _permission,
        uint256 _quantityToSpend
    ) external {
        s_addressToSpendPermission[msg.sender][_permission] = _quantityToSpend;
    }

    /* Public functions */
    /* Getters */

    /**
     * @return _address's funds
     */
    function getFunds(address _address) public view returns (uint256) {
        return s_addressToFunds[_address];
    }

    /**
     * @return If true = frozen, else if false = unfrozen
     */
    function getFrozen(address _address) public view returns (bool) {
        return s_addressToFrozen[_address];
    }

    /**
     * @return How much funds can be used to call a function. Check Permission enum mapping above.
     */
    function getFundsForPermission(
        address _address,
        PermissionsToCall _permission
    ) public view returns (uint256) {
        return s_addressToSpendPermission[_address][_permission];
    }

    /**
     * @return Addresses of contracts that IFM can call.
     */
    function getContracts() public view returns (address[] memory) {
        return s_yourContracts;
    }

    /* Internal functions */

    /**
     * @dev General template for a function that calls your contracts.
     * Need to implement AccessControl from OpenZeppelin if needed.
     *
     * @notice Emits event if everything went fine.
     *
     * @param _functionSignature it's value should be (using solidity language):
     * bytes memory _functionSignature = abi.encodeWithSignature("function(args)", arg1Value, arg2Value, ...);
     */
    function callFunction(
        bytes memory _functionSignature,
        address _contractToCall,
        address _clientAddress,
        PermissionsToCall _permission,
        uint256 _price
    )
        internal
        onlyOwner
        checkPermissions(_clientAddress, _permission, _price, _contractToCall)
        spendFunds(_clientAddress, _price)
        frozenAndDenyPermissionAfter(_clientAddress, _permission)
    {
        (bool success, ) = s_yourContracts[s_contractToIndex[_contractToCall]]
            .call{value: _price}(_functionSignature);
        if (!success) {
            revert IFM__FunctionCallFailed();
        }
        emit IFM__UsefulInfoInFunctionCall(_functionSignature);
    }
}
