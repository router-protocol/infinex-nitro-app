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

import { AppBeaconBase } from "src/apps/base/AppBeaconBase.sol";
import { ICurveStableSwapFactoryNG } from "src/interfaces/curve/ICurveStableSwapFactoryNG.sol";
import { ICurveStableSwapNG } from "src/interfaces/curve/ICurveStableSwapNG.sol";
import { ICurveStableSwapAppBeacon } from "src/interfaces/curve/ICurveStableSwapAppBeacon.sol";

import { CurveAppError } from "src/apps/curve/CurveAppError.sol";

contract CurveStableSwapAppBeacon is AppBeaconBase, ICurveStableSwapAppBeacon {
    address public immutable curveStableswapFactoryNG;
    mapping(address => bool) public isSupportedPool;
    address public immutable USDC;

    constructor(
        address _owner,
        address _latestAppImplementation,
        address _curveStableswapFactoryNG,
        address _usdc
    )
        AppBeaconBase(_owner, _latestAppImplementation, "CurveStableswap")
    {
        if (_curveStableswapFactoryNG == address(0)) revert CurveAppError.ZeroAddress();
        if (_usdc == address(0)) revert CurveAppError.ZeroAddress();
        curveStableswapFactoryNG = _curveStableswapFactoryNG;
        USDC = _usdc;
    }

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
        public
        view
        returns (PoolData memory poolData)
    {
        poolData.pool = ICurveStableSwapFactoryNG(curveStableswapFactoryNG).find_pool_for_coins(_fromToken, _toToken);
        poolData.tokens = ICurveStableSwapFactoryNG(curveStableswapFactoryNG).get_coins(poolData.pool);
        (poolData.fromTokenIndex, poolData.toTokenIndex, poolData.isUnderlying) =
            ICurveStableSwapFactoryNG(curveStableswapFactoryNG).get_coin_indices(poolData.pool, _fromToken, _toToken);
        poolData.balances = ICurveStableSwapFactoryNG(curveStableswapFactoryNG).get_balances(poolData.pool);
        poolData.decimals = ICurveStableSwapFactoryNG(curveStableswapFactoryNG).get_decimals(poolData.pool);
        poolData.amountReceived =
            ICurveStableSwapNG(poolData.pool).get_dy(poolData.fromTokenIndex, poolData.toTokenIndex, _fromAmount);
    }

    /**
     * @notice A safety feature to limit the pools that can be used by the app to only vetted and suppported pools
     * @dev Only the contract owner can call this function.
     * @param _pool The address of the pool.
     * @param _supported The supported status of the pool.
     */
    function setIsSupportedPool(address _pool, bool _supported) external onlyOwner {
        if (_pool == address(0)) revert CurveAppError.ZeroAddress();
        isSupportedPool[_pool] = _supported;
    }
}
