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

// from https://github.com/curvefi/stableswap-ng

/**
 * @title ICurveStableSwapNG
 * @notice Interface for the curve stable swap pool.
 */
interface ICurveStableSwapNG {
    /**
     * @notice Calculate the current input dx given output dy
     * @dev Index values can be found via the `coins` public getter method
     * @param i Index value for the coin to send
     * @param j Index value of the coin to receive
     * @param dy Amount of `j` being received after exchange
     * @return Amount of `i` predicted
     */
    function get_dx(int128 i, int128 j, uint256 dy) external view returns (uint256);

    /**
     * @notice Calculate the current output dy given input dx
     * @dev Index values can be found via the `coins` public getter method
     * @param i Index value for the coin to send
     * @param j Index value of the coin to receive
     * @param dx Amount of `i` being exchanged
     * @return Amount of `j` predicted
     */
    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);

    /**
     * @notice Calculate the amount received when withdrawing a single coin
     * @param _burn_amount Amount of LP tokens to burn in the withdrawal
     * @param i Index value of the coin to withdraw
     * @return Amount of coin received
     */
    function calc_withdraw_one_coin(uint256 _burn_amount, int128 i) external view returns (uint256);

    /**
     * @notice Returns the address of the token at the specified index.
     * @param i The index of the token.
     * @return The address of the token at the specified index.
     */
    function coins(uint256 i) external view returns (address);

    /**
     * @notice Returns the number of underlying coins in the pool.
     * @return The number of underlying coins in the pool.
     */
    function N_COINS() external view returns (uint256);

    /**
     * @notice Perform an exchange between two coins
     * @dev Index values can be found via the `coins` public getter method
     * @param i Index value for the coin to send
     * @param j Index value of the coin to receive
     * @param _dx Amount of `i` being exchanged
     * @param _min_dy Minimum amount of `j` to receive
     * @return Actual amount of `j` received
     */
    function exchange(int128 i, int128 j, uint256 _dx, uint256 _min_dy) external returns (uint256);

    /**
     * @notice Deposit coins into the pool
     * @param _amounts List of amounts of coins to deposit
     * @param _min_mint_amount Minimum amount of LP tokens to mint from the deposit
     * @return Amount of LP tokens received by depositing
     */
    function add_liquidity(uint256[] memory _amounts, uint256 _min_mint_amount) external returns (uint256);

    /**
     * @notice Withdraw a single coin from the pool
     * @param _burn_amount Amount of LP tokens to burn in the withdrawal
     * @param i Index value of the coin to withdraw
     * @param _min_received Minimum amount of coin to receive
     * @return Amount of coin received
     */
    function remove_liquidity_one_coin(
        uint256 _burn_amount,
        int128 i,
        uint256 _min_received
    )
        external
        returns (uint256);

    /**
     * @notice Withdraw coins from the pool in an imbalanced amount
     * @param _amounts List of amounts of underlying coins to withdraw
     * @param _max_burn_amount Maximum amount of LP token to burn in the withdrawal
     * @return Actual amount of the LP token burned in the withdrawal
     */
    function remove_liquidity_imbalance(
        uint256[] memory _amounts,
        uint256 _max_burn_amount
    )
        external
        returns (uint256);

    /**
     * @notice Withdraw coins from the pool
     * @dev Withdrawal amounts are based on current deposit ratios
     * @param _burn_amount Quantity of LP tokens to burn in the withdrawal
     * @param _min_amounts Minimum amounts of underlying coins to receive
     * @param _receiver Address that receives the withdrawn coins
     * @param _claim_admin_fees Whether to claim admin fees
     * @return List of amounts of coins that were withdrawn
     */
    function remove_liquidity(
        uint256 _burn_amount,
        uint256[] memory _min_amounts,
        address _receiver,
        bool _claim_admin_fees
    )
        external
        returns (uint256[] memory);
}
