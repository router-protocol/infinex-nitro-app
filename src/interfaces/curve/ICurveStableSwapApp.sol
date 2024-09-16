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
 * @title ICurveStableSwapApp
 * @notice Interface for the curve stable swap app.
 */
interface ICurveStableSwapApp {
    /*///////////////////////////////////////////////////////////////
    	 					    EVENTS
    ///////////////////////////////////////////////////////////////*/

    event TokensExchanged(
        address indexed stableSwapPool, address fromToken, address toToken, uint256 fromAmount, uint256 toAmount
    );
    event LiquidityAdded(address indexed stableSwapPool, uint256[] amounts, uint256 lpAmount);
    event LiquidityRemoved(address indexed stableSwapPool, uint256[] amounts, uint256 lpAmount);
    event LiquidityRemovedSingleToken(address indexed stableSwapPool, uint256 amountRemoved, uint256 lpAmountBurnt);

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
        external;

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
        external;

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
        returns (uint256);

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
        external;

    /**
     * @notice Swaps ERC20 tokens to USDC at the current exchange amount and then recovers to mainAccount
     * @param _stableSwapPool The address of the stable swap pool.
     * @param _fromToken The address of the ERC20 token to recover.
     * @param _minToAmount The minimum amount of USDC to receive.
     * @dev This function must be called by an authorized recovery party.
     */
    function recoverERC20ToUSDC(address _stableSwapPool, address _fromToken, uint256 _minToAmount) external;

    /**
     * @notice Removes all Liquidity as USDC with specified slippage amount and then recovers to mainAccount
     * @param _LPToken The address of the pool to remove liquidity from.
     * @param _USDCIndex The address of the LP token and pool to recover from.
     * @param _minReceiveAmount The minimum amount of USDC to receive.
     * @dev This function must be called by an authorized recovery party.
     */
    function recoverUSDCFromLP(address _LPToken, int128 _USDCIndex, uint256 _minReceiveAmount) external;

    /**
     * @notice Removes a single token from an LP for the purpose of recovery
     * @param _LPToken The address of the LP token/pool to remove liquidity from.
     * @param _tokenIndex The index of the token to remove from the liquidity pool
     * @param _minToAmount The minimum amount of token to withdraw from the liquidity pool.
     * @dev This function must be called by an authorized recovery party.
     */
    function recoverERC20FromLP(address _LPToken, int128 _tokenIndex, uint256 _minToAmount) external;
}
