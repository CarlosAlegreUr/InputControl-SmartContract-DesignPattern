// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "./IInputControl.sol";

/**
 * @title Input Control.
 * @author Carlos Alegre Urquizú (GitHub --> https://github.com/CarlosAlegreUr)
 *
 * @notice InputControl can be used to control which inputs can some addresses send to
 * your smart contracts' functions. Even more: in case of needing an specific order of inputs
 * in multiple calls to the same function, it's also handeled by InputControl.
 *
 * @dev Check an usecase on a contract at UseCaseContract.sol on the github repo:
 * [link](https://github.com/CarlosAlegreUr/InputControl-SmartContract-Testing/blob/main/contracts/owned/inheritanceVersion/UseCaseContract.sol)
 *
 */
contract InputControl is IInputControl {
    /* Types */

    /**
     * @dev This contract asumes that input Ids which == bytes32(0) are used or non-exiting
     * inputs.
     *
     * @notice In the following structs to manage allowed inputs, there is an array of inputs which
     * is useful to consult which inputs someone is allowed to use.
     *
     * But if anytime the input value is hashed and collides with 0 value in solidity, then inputs
     * array may not show properly the hashes of the inputs you can't and can use. Functionality will be
     * correct but off-chain user will have to take into account that one of the inputs is the colliding
     * with 0 one when analyzing their allowed inputs.
     */

    /**
     * @dev InputSequence struct allows the user tho call any input in the `inputs` array
     * but they must do it in the order they are indexed.
     *
     * Each bytes32 is the solidity's keckack hash representation of your inputs.
     * keckack(abi.encode(...inputs...))
     *
     * Example => First call must be done with the input at index 0, then the one at index 1,
     * then the index 2 value etc...
     */
    struct InputSequence {
        bytes32[] inputs;
        uint256 inputsToUse;
        uint256 currentCall;
    }

    /**
     * @dev InputUnordered struct allows the user to call any input in the inputs array
     * in any order. If desired to call the function with the same input twice, add the input
     * 2 times in the array and so on.
     *
     * @dev The `inputs` array in this struct has no functional purpose or essential role, it exists
     * just to be more 'off-chain-user-friendly' and let the user consult which inputs can still
     * use.
     *
     * @dev The only reason why `inputToPosition` exists is for a better storage space management of `inputs`
     * array when an input is used. Furhtermore, as the empty value in solidity for ints is 0, inputToIndex is
     * not being used because 0 index is a valid index and would also be the empty value. Thats why we are using
     * inputToPosition which its minimum valid value is 1.
     */
    struct InputUnordered {
        bytes32[] inputs;
        uint256 inputsToUse;
        mapping(bytes32 => uint256) inputToTimesToUse;
        mapping(bytes32 => uint256) inputToPosition;
    }

    /* State Variables */

    /**
     * @dev Check docs for `Permission` struct and the `PermissionState` state enum at IInputControlPublic.sol.
     */
    // State of a permission ID
    mapping(bytes32 => PermissionState) s_permissionState;
    // Permission ID to its corresponding alloed InputSequece
    mapping(bytes32 => InputSequence) s_inputsSequences;
    // Permission ID to its corresponding alloed InputUnordered
    mapping(bytes32 => InputUnordered) s_inputsUnordered;

    /* Modifiers */

    /// @notice Checks if a specific input is allowed for a permission.
    /// @param _allower In order to create the permission.
    /// @param _funcSelec In order to create the permission.
    /// @param _caller In order to create the permission.
    /// @param _input The input to check
    modifier isAllowedInput(address _allower, bytes4 _funcSelec, address _caller, bytes32 _input) {
        // Getting permission values needed
        Permission memory _p = Permission({allower: _allower, functionSelector: _funcSelec, caller: _caller});
        if (_p.caller != msg.sender) {
            revert InputControl__SenderIsNotPermissionCaller();
        }

        bytes32 pId = getPermissionId(_p);
        PermissionState currentState = s_permissionState[pId];

        // Checking permission state, only exeute if existing permission
        if (currentState == PermissionState.IS_NOT_EXISTING) {
            revert IInputControl.InputControl__PermissionDoesntExist();
        }

        // Use the proper checking for each structure
        // Return false statements should never execute, they are added just in case.
        if (currentState == PermissionState.IS_SEQUENCE) {
            _hanldeSequenceCheck(pId, _input);
        }
        if (currentState == PermissionState.IS_UNORDERED) {
            _hanldeUnorderedCheck(pId, _input);
        }
        _;
    }

    /* Functions */

    /**
     * @dev See documentation for the following public or external functions in IInputControl.sol:
     * (TODO: add link)
     *
     * @dev Private functions docs can be found here, down below.
     */

    /* Public Functions */
    /* Getters */

    function getPermissionId(Permission memory _p) public pure returns (bytes32) {
        return keccak256(abi.encode(_p.allower, _p.functionSelector, _p.caller));
    }

    function getPermissionState(Permission calldata _p) public view returns (IInputControl.PermissionState) {
        return s_permissionState[getPermissionId(_p)];
    }

    function getAllowedInputs(Permission calldata _p) public view returns (bytes32[] memory) {
        bytes32 pId = getPermissionId(_p);
        PermissionState pstate = s_permissionState[pId];
        if (pstate == PermissionState.IS_SEQUENCE) {
            return s_inputsSequences[pId].inputs;
        }
        if (pstate == PermissionState.IS_UNORDERED) {
            return s_inputsUnordered[pId].inputs;
        }
        return new bytes32[](0);
    }

    /**
     * @dev Override this function in your contract to use
     * callSetInputsPermission() mixed with other useful contracts and
     * modifiers like Owner and AccessControl contracts from
     * OpenZeppelin.
     *
     * See param specifications in callSetInputsPermission() docs.
     */
    function callSetInputsPermission(Permission calldata _p, bytes32[] calldata _validInputs, bool _isSequence)
        public
        virtual
    {
        _setInputsPermission(_p, _validInputs, _isSequence);
    }

    /* Private functions */

    /**
     * @dev Set permissions for the inputs with Ids in the _inputsIds. It's called by callSetInputsPermission()
     */
    function _setInputsPermission(Permission calldata _p, bytes32[] calldata _inputsIds, bool _isSequence) private {
        bytes32 pId = getPermissionId(_p);

        // Check if there is some storage to clean up.
        PermissionState currentState = s_permissionState[pId];
        if (currentState == PermissionState.IS_SEQUENCE) {
            _hanldeDeletionOfSequence(pId);
        }
        if (currentState == PermissionState.IS_UNORDERED) {
            _hanldeDeletionOfUnordered(pId);
        }

        // After cleaning up storage, or if the user is using control for the first time
        // sets the structs properly.
        if (_isSequence) {
            _handleNewSequencePermission(pId, _inputsIds);
        } else {
            _handleNewUnorderedPermission(pId, _inputsIds);
        }

        emit InputControl__InputsPermissionGranted(_p, s_permissionState[pId]);
    }

    /**
     * @dev This function creates a new InputSequence struct and indexes it with the `_permissionId` given.
     * Also updates the state for that permission ID to IS_SEQUENCE.
     *
     * @param _permissionId is the id of the permission being created.
     * @param _inputsIds is an array of the input hashes (ids) that want to be allowed.
     */
    function _handleNewSequencePermission(bytes32 _permissionId, bytes32[] calldata _inputsIds) private {
        // Saving values in a InputSequence structure
        InputSequence memory newSequence =
            InputSequence({inputs: _inputsIds, inputsToUse: _inputsIds.length, currentCall: 0});
        s_inputsSequences[_permissionId] = newSequence;

        // Updating permission state
        s_permissionState[_permissionId] = PermissionState.IS_SEQUENCE;
    }

    /**
     * @dev This function creates a new InputUnordered struct and indexes it with the `_permissionId` given.
     * Also updates the state for that permission ID to IS_UNORDERED.
     *
     * @param _permissionId is the id of the permission being created.
     * @param _inputsIds is an array of the input hashes (ids) that want to be allowed.
     */
    function _handleNewUnorderedPermission(bytes32 _permissionId, bytes32[] calldata _inputsIds) private {
        // Saving values in an InputUnordered structure
        s_inputsUnordered[_permissionId].inputs = _inputsIds;
        s_inputsUnordered[_permissionId].inputsToUse = _inputsIds.length;

        // Initializing the mapping values
        for (uint256 i = 0; i < _inputsIds.length; ++i) {
            s_inputsUnordered[_permissionId].inputToPosition[_inputsIds[i]] = i + 1;
            s_inputsUnordered[_permissionId].inputToTimesToUse[_inputsIds[i]] += 1;
        }

        // Updating permission state
        s_permissionState[_permissionId] = PermissionState.IS_UNORDERED;
    }

    /**
     * @dev Restes all values from the InputUnordered struct to 0
     * and sets the state of the `_permssionId` to IS_NOT_EXISTING.
     *
     * @notice Unordered structs are more expensive due to clearing up
     * mappings in storage.
     *
     * @param _permissionId is the id of the permission which struct
     * wants to be deleted (reseted to default 0 values)
     */
    function _hanldeDeletionOfUnordered(bytes32 _permissionId) private {
        bytes32[] memory inputs = s_inputsUnordered[_permissionId].inputs;

        // Resets map values
        for (uint256 i = 0; i < inputs.length; ++i) {
            delete s_inputsUnordered[_permissionId].inputToTimesToUse[inputs[i]];
            delete s_inputsUnordered[_permissionId].inputToPosition[inputs[i]];
        }
        // Reset other variables
        delete s_inputsUnordered[_permissionId].inputs;
        delete s_inputsUnordered[_permissionId].inputsToUse;

        // Reset permission state
        s_permissionState[_permissionId] = PermissionState.IS_NOT_EXISTING;
    }

    /**
     * @dev Restes all values from the InputSequence struct to 0
     * and sets the state of the `_permssionId` to IS_NOT_EXISTING.
     *
     * @param _permissionId is the id of the permission which struct
     * wants to be deleted (reseted to default 0 values)
     */
    function _hanldeDeletionOfSequence(bytes32 _permissionId) private {
        // Reset sequence struct
        delete s_inputsSequences[_permissionId];

        // Reset permission state
        s_permissionState[_permissionId] = PermissionState.IS_NOT_EXISTING;
    }

    /**
     * @dev This function, apart from checking if an input is valid, updates the
     * InputSequence parameters and handles proper storage deletion once an input
     * is used and once all of them are.
     *
     * @param _permissionId is the permission ID that points to the permission that wants to be checked.
     * @param _input is the hash representation (id) of the input being used by the caller.
     */
    function _hanldeSequenceCheck(bytes32 _permissionId, bytes32 _input) private {
        // Hanlding case deleted inputSequence case
        if (s_inputsSequences[_permissionId].inputsToUse == 0) {
            revert IInputControl.InputControl__NotAllowedInput();
        }

        // The main input check
        if (s_inputsSequences[_permissionId].inputs[s_inputsSequences[_permissionId].currentCall] != _input) {
            revert IInputControl.InputControl__NotAllowedInput();
        }

        // Updating inputSequence values
        s_inputsSequences[_permissionId].currentCall += 1;
        s_inputsSequences[_permissionId].inputsToUse -= 1;

        if (s_inputsSequences[_permissionId].inputsToUse != 0) {
            // Setting to bytes(0) value the input used in the input array.
            delete s_inputsSequences[_permissionId].inputs[
                        s_inputsSequences[_permissionId].currentCall - 1
                    ];
        } else {
            // All inputs used, reset struct.
            _hanldeDeletionOfSequence(_permissionId);
        }
    }

    /**
     * @dev This function, apart from checking if an input is valid, updates the
     * InputUnordered parameters and handles proper storage deletion once an input
     * is used and once all of them are.
     *
     * @param _permissionId is the permission ID that points to the permission that wants to be checked.
     * @param _input is the hash representation (id) of the input being used by the caller.
     */
    function _hanldeUnorderedCheck(bytes32 _permissionId, bytes32 _input) private {
        // Checking if the input exists or if has been used.
        if (
            s_inputsUnordered[_permissionId].inputToTimesToUse[_input] == 0
                || s_inputsUnordered[_permissionId].inputsToUse == 0
        ) {
            revert IInputControl.InputControl__NotAllowedInput();
        }

        // Updating InputUnordered structure values
        s_inputsUnordered[_permissionId].inputToTimesToUse[_input] -= 1;
        s_inputsUnordered[_permissionId].inputsToUse -= 1;

        if (s_inputsUnordered[_permissionId].inputsToUse != 0) {
            // Setting to bytes(0) value the input used in the input array.
            delete s_inputsUnordered[_permissionId].inputs[
                        s_inputsUnordered[_permissionId].
                            inputToPosition[_input] - 1
                    ];
        } else {
            // All imputs have been used, reset struct.
            _hanldeDeletionOfUnordered(_permissionId);
        }
    }
}
