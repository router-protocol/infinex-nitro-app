// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/**
 * @title IAppBeaconBase
 * @notice Interface for the App Beacon Base
 */
interface IAppBeaconBase {
    /*///////////////////////////////////////////////////////////////
    	 						STRUCTS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Struct containing the config for the app beacon.
     * @param appName The name of the app.
     * @param latestAppBeacon The address of the latest app beacon.
     */
    struct AppBeaconConfig {
        string appName;
        address latestAppBeacon;
    }

    /*///////////////////////////////////////////////////////////////
                                ERRORS
    ///////////////////////////////////////////////////////////////*/

    error ZeroAddress();
    error InvalidAppAccountImplementation();
    error InvalidAppBeacon();

    /*///////////////////////////////////////////////////////////////
    	 						EVENTS
    ///////////////////////////////////////////////////////////////*/

    event LatestAppImplementationSet(address latestAppImplementation);
    event LatestAppBeaconSet(address latestAppBeacon);

    /*///////////////////////////////////////////////////////////////
                    			VIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Gets the app implementation.
     * @return The address of the app implementation.
     */
    function APP_IMPLEMENTATION() external view returns (address);

    /**
     * @notice Gets the name of the app associated to the beacon.
     * @return The name of the app beacon.
     */
    function getAppName() external view returns (string memory);

    /**
     * @notice Gets the app implementation.
     * @return The address of the app implementation.
     */
    function getLatestAppImplementation() external view returns (address);

    /**
     * @notice Gets the latest beacon address for the app.
     * @return The address of the latest app beacon.
     */
    function getLatestAppBeacon() external view returns (address);

    /*///////////////////////////////////////////////////////////////
                    		    MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets the latest app beacon address.
     * @param _latestAppBeacon The address of the latest app beacon associated with the app.
     */
    function setLatestAppBeacon(address _latestAppBeacon) external;
}
