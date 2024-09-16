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

import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { AppAccountBase } from "src/apps/base/AppAccountBase.sol";
import { AppBase } from "src/apps/base/AppBase.sol";
import { CurveAppError } from "src/apps/curve/CurveAppError.sol";

import { ICurveStableSwapApp } from "src/interfaces/curve/ICurveStableSwapApp.sol";
import { ICurveStableSwapAppBeacon } from "src/interfaces/curve/ICurveStableSwapAppBeacon.sol";
import { ICurveStableSwapNG } from "src/interfaces/curve/ICurveStableSwapNG.sol";
import { ICurveStableSwapFactoryNG } from "src/interfaces/curve/ICurveStableSwapFactoryNG.sol";

contract CurveStableSwapApp is AppAccountBase, ICurveStableSwapApp {
    using SafeERC20 for IERC20;

    constructor() {
        _disableInitializers();
    }

    /*///////////////////////////////////////////////////////////////
                    			MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Allows the authorized operations party to exchange tokens on the stable swap pool.
     * @param _stableSwapPool The address of the stable swap pool.
     * @param _fromToken The address of the ERC20 token provided to exchange.
     * @param _toToken The address of the ERC20 token to receive from the exchange.
     * @param _fromAmount The amount of tokens to exchange.
     * @param _minToAmount The minimum amount of tokens to receive.
     */
    function exchange(
        address _stableSwapPool,
        address _fromToken,
        address _toToken,
        uint256 _fromAmount,
        uint256 _minToAmount
    )
        external
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        _validatePoolAddress(_stableSwapPool);
        // convert token addresses to pool indices, reverts if pool and tokens aren't valid
        (int128 fromTokenIndex, int128 toTokenIndex,) = ICurveStableSwapFactoryNG(
            _getAppBeacon().curveStableswapFactoryNG()
        ).get_coin_indices(_stableSwapPool, _fromToken, _toToken);
        IERC20(_fromToken).approve(_stableSwapPool, _fromAmount);
        uint256 receivedAmount =
            ICurveStableSwapNG(_stableSwapPool).exchange(fromTokenIndex, toTokenIndex, _fromAmount, _minToAmount);
        emit TokensExchanged(_stableSwapPool, _fromToken, _toToken, _fromAmount, receivedAmount);
    }

    /**
     * @notice Adds liquidity to the specified pool
     * @dev The arrays indices have to match the indices of the tokens in the pool.
     * @param _stableSwapPool The address of the pool to add liquidity to.
     * @param _tokens An array of token addresses to add as liquidity.
     * @param _amounts An array of token amounts to add as liquidity.
     * @param _minLPAmount The minimum amount of LP tokens to receive.
     */
    function addLiquidity(
        address _stableSwapPool,
        address[] calldata _tokens,
        uint256[] calldata _amounts,
        uint256 _minLPAmount
    )
        external
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        _validatePoolAddress(_stableSwapPool);
        address[] memory coins =
            ICurveStableSwapFactoryNG(_getAppBeacon().curveStableswapFactoryNG()).get_coins(_stableSwapPool);
        // check and approve the pool to add the tokens as liquidity
        for (uint256 i = 0; i < _tokens.length; i++) {
            if (coins[i] != _tokens[i]) revert CurveAppError.InvalidToken();
            IERC20(_tokens[i]).approve(_stableSwapPool, _amounts[i]);
        }

        // provide the liquidity
        uint256 lpAmount = ICurveStableSwapNG(_stableSwapPool).add_liquidity(_amounts, _minLPAmount);
        emit LiquidityAdded(_stableSwapPool, _amounts, lpAmount);
    }

    /**
     * @notice Removes liquidity for a single token from the Curve stable swap pool.
     * @param _stableSwapPool The address of the Curve stable swap pool.
     * @param _tokenIndex The index of the token to remove liquidity.
     * @param _lpAmount The amount of LP tokens to burn.
     * @param _minReceiveAmount The minimum amount of tokens to receive in return.
     * @return The amount of tokens received after removing liquidity.
     */
    function removeSingleTokenLiquidity(
        address _stableSwapPool,
        int128 _tokenIndex,
        uint256 _lpAmount,
        uint256 _minReceiveAmount
    )
        external
        nonReentrant
        requiresAuthorizedOperationsParty
        returns (uint256)
    {
        return _removeSingleTokenLiquidity(_stableSwapPool, _tokenIndex, _lpAmount, _minReceiveAmount);
    }

    /**
     * @notice Withdraw coins from a Curve stable swap pool in an imbalanced amount.
     * @param _stableSwapPool The address of the Curve stable swap pool.
     * @param _lpAmount The max amount of LP tokens to burn.
     * @param _amounts The amount of tokens to receive in return.
     */
    function removeLiquidityImbalance(
        address _stableSwapPool,
        uint256 _lpAmount,
        uint256[] calldata _amounts
    )
        external
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        _removeLiquidityImbalance(_stableSwapPool, _lpAmount, _amounts);
    }

    /**
     * @notice Swaps ERC20 tokens to USDC at the current exchange amount and then recovers to mainAccount
     * @param _stableSwapPool The address of the stable swap pool.
     * @param _fromToken The address of the ERC20 token to recover.
     * @param _minToAmount The minimum amount of USDC to receive.
     * @dev This function must be called by an authorized recovery party.
     */
    function recoverERC20ToUSDC(
        address _stableSwapPool,
        address _fromToken,
        uint256 _minToAmount
    )
        external
        nonReentrant
        requiresAuthorizedRecoveryParty
    {
        _validatePoolAddress(_stableSwapPool);
        uint256 balance = IERC20(_fromToken).balanceOf(address(this));
        ICurveStableSwapAppBeacon appBeacon = _getAppBeacon();
        address USDC = appBeacon.USDC();
        // convert token addresses to pool indices, reverts if pool and tokens aren't valid
        (int128 fromTokenIndex, int128 toTokenIndex,) = ICurveStableSwapFactoryNG(
            _getAppBeacon().curveStableswapFactoryNG()
        ).get_coin_indices(_stableSwapPool, _fromToken, USDC);
        IERC20(_fromToken).approve(_stableSwapPool, balance);
        // swap to USDC
        uint256 receivedAmount =
            ICurveStableSwapNG(_stableSwapPool).exchange(fromTokenIndex, toTokenIndex, balance, _minToAmount);
        emit TokensExchanged(_stableSwapPool, _fromToken, USDC, balance, receivedAmount);
        uint256 USDCRecoverBalance = IERC20(USDC).balanceOf(address(this));
        emit ERC20RecoveredToMainAccount(USDC, USDCRecoverBalance);
        _transferERC20ToMainAccount(USDC, USDCRecoverBalance);
    }

    /**
     * @notice Removes all Liquidity as USDC with specified slippage amount and then recovers to mainAccount
     * @param _LPToken The address of the pool to remove liquidity from.
     * @param _USDCIndex The address of the LP token and pool to recover from.
     * @param _minReceiveAmount The minimum amount of USDC to receive.
     * @dev This function must be called by an authorized recovery party.
     */
    function recoverUSDCFromLP(
        address _LPToken,
        int128 _USDCIndex,
        uint256 _minReceiveAmount
    )
        external
        nonReentrant
        requiresAuthorizedRecoveryParty
    {
        // pool address is validated by _removeSingleTokenLiquidity
        ICurveStableSwapAppBeacon appBeacon = _getAppBeacon();
        address USDC = appBeacon.USDC();

        if (ICurveStableSwapNG(_LPToken).coins(uint256(uint128(_USDCIndex))) != USDC) {
            revert CurveAppError.TokenIndexMismatch();
        }

        // recover funds
        uint256 lpBalance = IERC20(_LPToken).balanceOf(address(this));

        // the LP token is the pool address
        _removeSingleTokenLiquidity(_LPToken, _USDCIndex, lpBalance, _minReceiveAmount);

        uint256 USDCBalance = IERC20(USDC).balanceOf(address(this));

        emit ERC20RecoveredToMainAccount(USDC, USDCBalance);
        _transferERC20ToMainAccount(USDC, USDCBalance);
    }

    /**
     * @notice Removes a single token from an LP for the purpose of recovery
     * @param _LPToken The address of the LP token/pool to remove liquidity from.
     * @param _tokenIndex The index of the token to remove from the liquidity pool
     * @param _minToAmount The minimum amount of token to withdraw from the liquidity pool.
     * @dev This function must be called by an authorized recovery party.
     */
    function recoverERC20FromLP(
        address _LPToken,
        int128 _tokenIndex,
        uint256 _minToAmount
    )
        external
        nonReentrant
        requiresAuthorizedRecoveryParty
    {
        // pool address is validated by _removeSingleTokenLiquidity
        // remove token from pool
        uint256 lpBalance = IERC20(_LPToken).balanceOf(address(this));
        _removeSingleTokenLiquidity(_LPToken, _tokenIndex, lpBalance, _minToAmount);
    }

    /*///////////////////////////////////////////////////////////////
                                INTERNAL FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Removes liquidity for a single token from the Curve stable swap pool.
     * @param _stableSwapPool The address of the Curve stable swap pool.
     * @param _tokenIndex The index of the token to remove liquidity for.
     * @param _lpAmount The amount of LP tokens to burn.
     * @param _minReceiveAmount The minimum amount of tokens to receive in return.
     * @return amountRemoved The amount of tokens that were removed from the pool.
     */
    function _removeSingleTokenLiquidity(
        address _stableSwapPool,
        int128 _tokenIndex,
        uint256 _lpAmount,
        uint256 _minReceiveAmount
    )
        internal
        returns (uint256 amountRemoved)
    {
        _validatePoolAddress(_stableSwapPool);
        amountRemoved =
            ICurveStableSwapNG(_stableSwapPool).remove_liquidity_one_coin(_lpAmount, _tokenIndex, _minReceiveAmount);
        emit LiquidityRemovedSingleToken(_stableSwapPool, amountRemoved, _lpAmount);
    }

    /**
     * @notice Withdraw coins from a Curve stable swap pool in an imbalanced amount.
     * @param _stableSwapPool The address of the Curve stable swap pool.
     * @param _lpAmount The max amount of LP tokens to be burned for the token amounts to be removed
     * @param _amounts The amounts of tokens to be removed from the pool.
     */
    function _removeLiquidityImbalance(
        address _stableSwapPool,
        uint256 _lpAmount,
        uint256[] calldata _amounts
    )
        internal
    {
        _validatePoolAddress(_stableSwapPool);
        uint256 amountLPBurnt = ICurveStableSwapNG(_stableSwapPool).remove_liquidity_imbalance(_amounts, _lpAmount);
        emit LiquidityRemoved(_stableSwapPool, _amounts, amountLPBurnt);
    }

    function _validatePoolAddress(address _stableSwapPool) internal view {
        ICurveStableSwapAppBeacon appBeacon = _getAppBeacon();
        if (!appBeacon.isSupportedPool(_stableSwapPool)) revert CurveAppError.UnsupportedPool(_stableSwapPool);
        if (
            ICurveStableSwapFactoryNG(appBeacon.curveStableswapFactoryNG()).get_implementation_address(_stableSwapPool)
                == address(0)
        ) {
            revert CurveAppError.InvalidPoolAddress(_stableSwapPool);
        }
    }

    /**
     * @dev Returns the beacon contract for the Curve StableSwap app.
     * @return The beacon contract for the Curve StableSwap app.
     */
    function _getAppBeacon() internal view returns (ICurveStableSwapAppBeacon) {
        return (ICurveStableSwapAppBeacon(AppBase._getAppBeacon()));
    }
}
