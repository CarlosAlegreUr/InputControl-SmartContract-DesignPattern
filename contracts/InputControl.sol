// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/* Customed Errors */
error InputControl__NotAllowedInput();

// Uncomment this line to use console.log
// import "hardhat/console.sol";

/**
 * @title Input Control.
 * @author Carlos Alegre Urquizú (GitHub --> https://github.com/CarlosAlegreUr)
 *
 * @notice InputControl can be used to control which inputs can some addresses send to
 * your smart contracts functions.
 *
 * @dev Check how to use it in your contracts at the UseCaseContract on the github repo: 
 * https://github.com/CarlosAlegreUr/InputControl-SmartContract-DesignPattern/blob/main/contracts/UseCaseContract.sol
 * 
 */
contract InputControl {
    /* Types */
    struct inputSequence {
        uint256 numOfCalls;
        bytes32[] inputs;
        uint256 actualCall;
    }

    /* State Variables */

    mapping(string => mapping(address => inputSequence)) s_funcSignatureToAllowedInputSequence;

    /* Events */
    event InputControl__AllowedInputsGranted(
        address indexed client,
        string indexed funcSig,
        bytes32[] validInputs
    );

    /* Modifiers */

    /**
     * @dev Checks if `_client` can call `_funcSignature` with `_input`.
     * If `_client` has used all it's calls, this modifier also resets
     * the inputSequence that associates `_client` with `_funcSignature`.
     */
    modifier isAllowedInput(
        string memory _funcSig,
        address _clientAddress,
        bytes32 _input
    ) {
        inputSequence memory seq = s_funcSignatureToAllowedInputSequence[
            _funcSig
        ][_clientAddress];
        if (seq.numOfCalls != 0) {
            if (seq.inputs[seq.actualCall] != _input) {
                revert InputControl__NotAllowedInput();
            }

            if ((seq.actualCall + 1) == seq.numOfCalls) {
                delete s_funcSignatureToAllowedInputSequence[_funcSig][
                    _clientAddress
                ];
            } else {
                s_funcSignatureToAllowedInputSequence[_funcSig][_clientAddress]
                    .actualCall += 1;
            }
        } else {
            revert InputControl__NotAllowedInput();
        }
        _;
    }

    /* Functions */

    /* Public functions */
    /* Getters */

    /**
     * @return Allowed inputs from `_address` when calling `_funcSignature`. Index of inputs
     * on the inputs array shows in which order when calling `_funcSignature` that input can be used.
     */
    function getAllowedInputs(
        string memory _funcSignature,
        address _address
    ) public view returns (bytes32[] memory) {
        return
            s_funcSignatureToAllowedInputSequence[_funcSignature][_address]
                .inputs;
    }

    /* Internal functions */

    /**
     * @dev Override this function in your contract to use
     * allowInputsFor() mixed with other useful contracts and
     * modifiers like Owner and AccessControl contracts of
     * OpenZeppelin.
     *
     * See param specifications in allowInputsFor() docs.
     */
    function callAllowInputsFor(
        address _client,
        bytes32[] calldata _validInputs,
        string calldata _funcSignature
    ) public virtual {
        allowInputsFor(_client, _validInputs, _funcSignature);
    }

    /**
     * @dev Allows `_client` to call `_funcSignature` with `_validInputs`
     * `_validInputs.length` times with the value _validInputs[callNumber] in
     * each call.
     *
     * @param _validInputs Each element must correspond to the equivalent of
     * executing in solidity the next funtions with the values of the inputs:
     * validInputUniqueIdentifier = keccak256(abi.encodePacked(input))
     *
     * @param _funcSignature should be a name you want to give to your function,
     * could be any but for consistency I recommend putting the name of the function
     * with it's datatypes =>  _funcSignature = funcName(arg1, arg2, ...)
     *
     * Example:
     * For allowInputsFor() function => _funcSignature = "allowInputsFor(address, bytes32[], string)"
     */
    function allowInputsFor(
        address _client,
        bytes32[] calldata _validInputs,
        string calldata _funcSignature
    ) internal {
        s_funcSignatureToAllowedInputSequence[_funcSignature][_client]
            .numOfCalls = _validInputs.length;
        s_funcSignatureToAllowedInputSequence[_funcSignature][_client]
            .actualCall = 0;
        s_funcSignatureToAllowedInputSequence[_funcSignature][_client]
            .inputs = _validInputs;

        emit InputControl__AllowedInputsGranted(
            _client,
            _funcSignature,
            _validInputs
        );
    }
}
