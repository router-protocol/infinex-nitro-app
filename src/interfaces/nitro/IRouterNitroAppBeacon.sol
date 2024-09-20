// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/**
 * @title IRouterNitroAppBeacon
 * @dev Interface for the Nitro App Beacon Router.
 */
interface IRouterNitroAppBeacon {
    /**
     * @dev Returns the address of the Nitro Gateway Router.
     * @return The address of the Nitro Gateway Router.
     */
    function routerNitroGateway() external view returns (address);

    /**
     * @dev Returns the address of the Asset Bridge Gateway Router.
     * @return The address of the Asset Bridge Gateway Router.
     */
    function routerAssetBridgeGateway() external view returns (address);
}
