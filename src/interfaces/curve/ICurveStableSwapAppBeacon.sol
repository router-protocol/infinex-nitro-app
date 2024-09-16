//       c=<
//        |
//        |   ////\    1@2
//    @@  |  /___\**   @@@2			@@@@@@@@@@@@@@@@@@@@@@
//   @@@  |  |~L~ |*   @@@@@@		@@@  @@@@@        @@@@    @@@ @@@@    @@@  @@@@@@@@ @@@@ @@@@    @@@ @@@@@@@@@ @@@@   @@@@
//  @@@@@ |   \=_/8    @@@@1@@		@@@  @@@@@  @@@@  @@@@    @@@ @@@@@   @@@ @@@@@@@@@ @@@@ @@@@@  @@@@ @@@@@@@@@  @@@@
// @@@@
// @@@@@@| _ /| |\__ @@@@@@@@2		@@@  @@@@@  @@@@  @@@@    @@@ @@@@@@@ @@@ @@@@      @@@@ @@@@@@ @@@@ @@@         @@@@@@@
// 1@@@@@@|\  \___/)   @@1@@@@@2	~~~  ~~~~~  @@@@  ~~@@    ~~~ ~~~~~~~~~~~ ~~~~      ~~~~ ~~~~~~~~~~~ ~@@          @@@@@
// 2@@@@@ |  \ \ / |     @@@@@@2	@@@  @@@@@  @@@@  @@@@    @@@ @@@@@@@@@@@ @@@@@@@@@ @@@@ @@@@@@@@@@@ @@@@@@@@@    @@@@@
// 2@@@@  |_  >   <|__    @@1@12	@@@  @@@@@  @@@@  @@@@    @@@ @@@@ @@@@@@ @@@@      @@@@ @@@@ @@@@@@ @@@         @@@@@@@
// @@@@  / _|  / \/    \   @@1@		@@@   @@@   @@@@  @@@@    @@@ @@@@  @@@@@ @@@@      @@@@ @@@@  @@@@@ @@@@@@@@@  @@@@
// @@@@
//  @@ /  |^\/   |      |   @@1		@@@         @@@@  @@@@    @@@ @@@@    @@@ @@@@      @@@@ @@@    @@@@ @@@@@@@@@ @@@@   @@@@
//   /     / ---- \ \\\=    @@		@@@@@@@@@@@@@@@@@@@@@@
//   \___/ --------  ~~    @@@
//     @@  | |   | |  --   @@
// ————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/**
 * @title ICurveStableSwapAppBeacon
 * @notice Interface for the curve app beacon.
 */
interface ICurveStableSwapAppBeacon {
    /*///////////////////////////////////////////////////////////////
    	 				        STRUCTS
    ///////////////////////////////////////////////////////////////*/

    struct PoolData {
        address pool;
        int128 fromTokenIndex;
        int128 toTokenIndex;
        uint256 amountReceived;
        address[] tokens;
        uint256[] balances;
        uint256[] decimals;
        bool isUnderlying;
    }

    /*///////////////////////////////////////////////////////////////
    	 				    VIEW FUNCTIONS/VARIABLES
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Gets the curve stable swap factory address.
     * @return The address of the curve stable swap factory.
     */
    function curveStableswapFactoryNG() external view returns (address);

    /**
     * @notice Gets the USDC address.
     * @return The address of the USDC token.
     */
    function USDC() external view returns (address);

    /**
     * @notice Checks if a pool has been vetted by the council and can be safely used by the app
     * @param _pool The address of the pool.
     * @return True if the pool is supported, false otherwise.
     */
    function isSupportedPool(address _pool) external view returns (bool);

    /**
     * @notice Get the pool data for the given tokens. Data will be empty if type is underyling
     * @param _fromToken The address of the token to swap from.
     * @param _toToken The address of the token to swap to.
     * @return poolData The pool data for the given tokens.
     */
    function getPoolDatafromTokens(
        address _fromToken,
        address _toToken,
        uint256 _fromAmount
    )
        external
        returns (PoolData memory poolData);

    /**
     * @notice A safety feature to limit the pools that can be used by the app to only vetted and suppported pools
     * @dev Only the contract owner can call this function.
     * @param _pool The address of the pool.
     * @param _supported The supported status of the pool.
     */
    function setIsSupportedPool(address _pool, bool _supported) external;
}
