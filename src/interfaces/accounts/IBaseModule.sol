// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { RequestTypes } from "src/accounts/utils/RequestTypes.sol";

interface IBaseModule {
    /*///////////////////////////////////////////////////////////////
                    			EVENTS / ERRORS
    ///////////////////////////////////////////////////////////////*/

    event AccountImplementationUpgraded(address accountImplementation);
    event AccountMigratedFrom(uint64 previousVersion, uint64 currentVersion);

    /*///////////////////////////////////////////////////////////////
                                 		INITIALIZER
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Initialize the account with the sudo key
     */
    function initialize(address _sudoKey) external;

    /**
     * @notice Reinitialize the account with the current version
     * @dev Only to be called by the upgradeTo function
     */
    function reinitialize(uint64 _previousVersion) external;

    /**
     * @notice Reinitialize the account with the current version
     * @dev Only to be called once to reinitialize accounts created with v1
     */
    function reinitializeLegacyAccount() external;

    /*///////////////////////////////////////////////////////////////
                                    VIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the version number of the account.
     * @return A uint64 representing the version of the account.
     * @dev The version number is provided by the OZ Initializable library
     */
    function accountVersion() external view returns (uint64);

    /**
     * @notice Check if the provided nonce is valid
     * @param _nonce The nonce to check
     * @return A boolean indicating if the nonce is valid
     */
    function isValidNonce(bytes32 _nonce) external view returns (bool);

    /**
     * @notice Check if the provided forwarder is trusted
     * @param _forwarder The forwarder to check
     * @return A boolean indicating if the forwarder is trusted
     */
    function isTrustedForwarder(address _forwarder) external view returns (bool);

    /**
     * @notice Get all trusted forwarders
     * @return An array of addresses of all trusted forwarders
     */
    function trustedForwarders() external view returns (address[] memory);

    /*///////////////////////////////////////////////////////////////
                    			MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Enables or disables an operation key for the account
     * @param _operationKey The address of the operation key to be set
     * @param _isValid Whether the key is to be set as valid or invalid
     * @dev This function requires the sender to be the sudo key holder
     */
    function setOperationKeyStatus(address _operationKey, bool _isValid) external;

    /**
     * @notice Enables or disables a recovery key for the account
     * @param _recoveryKey The address of the recovery key to be set
     * @param _isValid Whether the key is to be set as valid or invalid
     * @dev This function requires the sender to be the sudo key holder
     */
    function setRecoveryKeyStatus(address _recoveryKey, bool _isValid) external;

    /**
     * @notice Enables or disables a sudo key for the account
     * @param _sudoKey The address of the sudo key to be set
     * @param _isValid Whether the key is to be set as valid or invalid
     * @dev This function requires the sender to be the sudo key holder
     */
    function setSudoKeyStatus(address _sudoKey, bool _isValid) external;

    /**
     * @notice Add a new trusted forwarder
     * @param _request The Request struct containing:
     *  RequestData {
     *  address _address; - The address of the new trusted forwarder.
     *	bytes32 _nonce; - The nonce of the signature
     *  }
     * @param _signature The required signature for executing the transaction
     * Required signature:
     * - sudo key
     */
    function addTrustedForwarder(RequestTypes.Request calldata _request, bytes calldata _signature) external;

    /**
     * @notice Remove a trusted forwarder
     * @param _request The Request struct containing:
     *  RequestData {
     *  address _address; - The address of the trusted forwarder to be removed.
     *	bytes32 _nonce; - The nonce of the signature
     *  }
     * @param _signature The required signature for executing the transaction
     * Required signature:
     * - sudo key
     */
    function removeTrustedForwarder(RequestTypes.Request calldata _request, bytes calldata _signature) external;
}
