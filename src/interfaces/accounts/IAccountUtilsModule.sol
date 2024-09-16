// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

interface IAccountUtilsModule {
    event AccountInfinexProtocolBeaconImplementationUpgraded(address infinexProtocolConfigBeacon);

    event AccountSynthetixInformationBeaconUpgraded(address synthetixInformationBeacon);

    event AccountCircleBridgeParamsUpgraded(
        address circleBridge, address circleMinter, uint32 defaultDestinationCCTPDomain
    );

    event AccountWormholeCircleBridgeParamsUpgraded(
        address wormholeCircleBridge, uint16 defaultDestinationWormholeChainId
    );

    event AccountUSDCAddressUpgraded(address USDC);

    /*///////////////////////////////////////////////////////////////
                                    VIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Get the Infinex Protocol Config
     * @return The Infinex Protocol Config Beacon
     */
    function infinexProtocolConfigBeacon() external view returns (address);

    /**
     * @notice Check if the provided operation key is valid
     * @param _operationKey The operation key to check
     * @return A boolean indicating if the key is valid
     */
    function isValidOperationKey(address _operationKey) external view returns (bool);

    /**
     * @notice Check if the provided sudo key is valid
     * @param _sudoKey The sudo key to check
     * @return A boolean indicating if the sudo key is valid
     */
    function isValidSudoKey(address _sudoKey) external view returns (bool);

    /**
     * @notice Check if the provided recovery key is valid
     * @param _recoveryKey The recovery key to check
     * @return A boolean indicating if the recovery key is valid
     */
    function isValidRecoveryKey(address _recoveryKey) external view returns (bool);

    /**
     * @notice Checks if the given address is an authorized operations party.
     * @param _key The address to check.
     * @return A boolean indicating whether the address is an authorized operations party.
     * @dev Update this function whenever the logic for requiresAuthorizedOperationsParty
     * from SecurityModifiers changes
     */
    function isAuthorizedOperationsParty(address _key) external view returns (bool);

    /**
     * @notice Checks if the given address is an authorized recovery party.
     * @param _key The address to check.
     * @return A boolean indicating whether the address is an authorized recovery party.
     * @dev Update this function whenever the logic for requiresAuthorizedRecoveryParty
     * from SecurityModifiers changes
     */
    function isAuthorizedRecoveryParty(address _key) external view returns (bool);

    /**
     * @notice Retrieves the Circle Bridge parameters.
     * @return The address of the circleBridge
     * @return The address of the minter.
     * @return The default circle bridge destination domain.
     */
    function getCircleBridgeParams() external view returns (address, address, uint32);

    /**
     * @notice Retrieves the wormhole circle bridge
     * @return The wormhole circle bridge address.
     */
    function getWormholeCircleBridge() external view returns (address);

    /**
     * @notice Retrieves the Wormhole Circle Bridge parameters.
     * @return The address of the wormholeCircleBridge
     * @return The address of the wormholeCircleBridge and the default defaultDestinationWormholeChainId
     */
    function getWormholeCircleBridgeParams() external view returns (address, uint16);

    /**
     * @notice Retrieves the USDC address.
     * @return The address of USDC
     */
    function getUSDCAddress() external view returns (address);

    /**
     * @notice Retrieves the maximum withdrawal fee.
     * @return The maximum withdrawal fee.
     */
    function getMaxWithdrawalFee() external pure returns (uint256);

    /*///////////////////////////////////////////////////////////////
                                MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Upgrade to a new beacon implementation and updates any new parameters along with it
     * @param _newInfinexProtocolConfigBeacon The address of the new beacon
     * @dev requires the sender to be the sudo key
     * @dev Requires passing the new beacon address which matches the latest to ensure that the upgrade both
     * is as the user intended, and is to the latest beacon implementation. Prevents the user from opting in to a
     * specific version and upgrading to a later version that may have been deployed between the opt-in and the upgrade
     */
    function upgradeProtocolBeaconParameters(address _newInfinexProtocolConfigBeacon) external;

    /**
     * @notice Updates the parameters for the Circle Bridge to the latest from the Infinex Protocol Config Beacon.
     * Update is opt in to prevent malicious automatic updates.
     * @dev requires the sender to be the sudo key
     */
    function updateCircleBridgeParams() external;

    /**
     * @notice Updates the parameters for the Wormhole Circle Bridge to the latest from the Infinex Protocol Config
     * Beacon.
     * Update is opt in to prevent malicious automatic updates.
     * @dev requires the sender to be the sudo key
     */
    function updateWormholeCircleBridge() external;

    /**
     * @notice Updates the USDC address from the Infinex Protocol Config Beacon.
     * Update is opt in to prevent malicious automatic updates.
     * @dev requires the sender to be the sudo key
     */
    function updateUSDCAddress() external;
}
