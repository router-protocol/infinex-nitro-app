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
 * @title ICurveStableSwapFactoryNG
 * @notice Interface for the curve stable swap factory.
 */
interface ICurveStableSwapFactoryNG {
    /**
     * @notice Find an available pool for exchanging two coins
     * @param _from Address of coin to be sent
     * @param _to Address of coin to be received
     * @param i Index value. When multiple pools are available
     *        this value is used to return the n'th address.
     * @return Pool address
     */
    function find_pool_for_coins(address _from, address _to, uint256 i) external view returns (address);

    /**
     * @notice Find an available pool for exchanging two coins
     * @param _from Address of coin to be sent
     * @param _to Address of coin to be received
     * @return Pool address
     */
    function find_pool_for_coins(address _from, address _to) external view returns (address);

    /**
     * @notice Get the base pool for a given factory metapool
     * @param _pool Metapool address
     * @return Address of base pool
     */
    function get_base_pool(address _pool) external view returns (address);

    /**
     * @notice Get the number of coins in a pool
     * @param _pool Pool address
     * @return Number of coins
     */
    function get_n_coins(address _pool) external view returns (uint256);

    /**
     * @notice Get the coins within a pool
     * @param _pool Pool address
     * @return List of coin addresses
     */
    function get_coins(address _pool) external view returns (address[] memory);

    /**
     * @notice Get the underlying coins within a pool
     * @dev Reverts if a pool does not exist or is not a metapool
     * @param _pool Pool address
     * @return List of coin addresses
     */
    function get_underlying_coins(address _pool) external view returns (address[] memory);

    /**
     * @notice Get decimal places for each coin within a pool
     * @param _pool Pool address
     * @return uint256 list of decimals
     */
    function get_decimals(address _pool) external view returns (uint256[] memory);

    /**
     * @notice Get decimal places for each underlying coin within a pool
     * @param _pool Pool address
     * @return uint256 list of decimals
     */
    function get_underlying_decimals(address _pool) external view returns (uint256[] memory);

    /**
     * @notice Get rates for coins within a metapool
     * @param _pool Pool address
     * @return Rates for each coin, precision normalized to 10**18
     */
    function get_metapool_rates(address _pool) external view returns (uint256[] memory);

    /**
     * @notice Get balances for each coin within a pool
     * @dev For pools using lending, these are the wrapped coin balances
     * @param _pool Pool address
     * @return uint256 list of balances
     */
    function get_balances(address _pool) external view returns (uint256[] memory);

    /**
     * @notice Get balances for each underlying coin within a metapool
     * @param _pool Metapool address
     * @return uint256 list of underlying balances
     */
    function get_underlying_balances(address _pool) external view returns (uint256[] memory);

    /**
     * @notice Get the amplfication co-efficient for a pool
     * @param _pool Pool address
     * @return uint256 A
     */
    function get_A(address _pool) external view returns (uint256);

    /**
     * @notice Get the fees for a pool
     * @dev Fees are expressed as integers
     * @param _pool Pool address
     * @return Pool fee and admin fee as uint256 with 1e10 precision
     */
    function get_fees(address _pool) external view returns (uint256, uint256);

    /**
     * @notice Get the current admin balances (uncollected fees) for a pool
     * @param _pool Pool address
     * @return List of uint256 admin balances
     */
    function get_admin_balances(address _pool) external view returns (uint256[] memory);

    /**
     * @notice Convert coin addresses to indices for use with pool methods
     * @param _pool Pool address
     * @param _from Coin address to be used as `i` within a pool
     * @param _to Coin address to be used as `j` within a pool
     * @return int128 `i`, int128 `j`, boolean indicating if `i` and `j` are underlying coins
     */
    function get_coin_indices(address _pool, address _from, address _to) external view returns (int128, int128, bool);

    /**
     * @notice Get the address of the liquidity gauge contract for a factory pool
     * @dev Returns `empty(address)` if a gauge has not been deployed
     * @param _pool Pool address
     * @return Implementation contract address
     */
    function get_gauge(address _pool) external view returns (address);

    /**
     * @notice Get the address of the implementation contract used for a factory pool
     * @param _pool Pool address
     * @return Implementation contract address
     */
    function get_implementation_address(address _pool) external view returns (address);

    /**
     * @notice Verify `_pool` is a metapool
     * @param _pool Pool address
     * @return True if `_pool` is a metapool
     */
    function is_meta(address _pool) external view returns (bool);

    /**
     * @notice Query the asset type of `_pool`
     * @param _pool Pool Address
     * @return Dynarray of uint8 indicating the pool asset type
     *         Asset Types:
     *             0. Standard ERC20 token with no additional features
     *             1. Oracle - token with rate oracle (e.g. wrapped staked ETH)
     *             2. Rebasing - token with rebase (e.g. staked ETH)
     *             3. ERC4626 - e.g. sDAI
     */
    function get_pool_asset_types(address _pool) external view returns (uint8[] memory);

    /**
     * @notice Deploy a new plain pool
     * @param _name Name of the new plain pool
     * @param _symbol Symbol for the new plain pool - will be
     *                concatenated with factory symbol
     * @param _coins List of addresses of the coins being used in the pool.
     * @param _A Amplification co-efficient - a lower value here means
     *           less tolerance for imbalance within the pool's assets.
     *           Suggested values include:
     *            * Uncollateralized algorithmic stablecoins: 5-10
     *            * Non-redeemable, collateralized assets: 100
     *            * Redeemable assets: 200-400
     * @param _fee Trade fee, given as an integer with 1e10 precision. The
     *             maximum is 1% (100000000). 50% of the fee is distributed to veCRV holders.
     * @param _offpeg_fee_multiplier Off-peg fee multiplier
     * @param _ma_exp_time Averaging window of oracle. Set as time_in_seconds / ln(2)
     *                     Example: for 10 minute EMA, _ma_exp_time is 600 / ln(2) ~= 866
     * @param _implementation_idx Index of the implementation to use
     * @param _asset_types Asset types for pool, as an integer
     * @param _method_ids Array of first four bytes of the Keccak-256 hash of the function signatures
     *                    of the oracle addresses that gives rate oracles.
     *                    Calculated as: keccak(text=event_signature.replace(" ", ""))[:4]
     * @param _oracles Array of rate oracle addresses.
     * @return Address of the deployed pool
     */
    function deploy_plain_pool(
        string memory _name,
        string memory _symbol,
        address[] memory _coins,
        uint256 _A,
        uint256 _fee,
        uint256 _offpeg_fee_multiplier,
        uint256 _ma_exp_time,
        uint256 _implementation_idx,
        uint8[] memory _asset_types,
        bytes4[] memory _method_ids,
        address[] memory _oracles
    )
        external
        returns (address);
    /**
     * @notice Deploy a new metapool
     * @param _base_pool Address of the base pool to use
     *                   within the metapool
     * @param _name Name of the new metapool
     * @param _symbol Symbol for the new metapool - will be
     *                concatenated with the base pool symbol
     * @param _coin Address of the coin being used in the metapool
     * @param _A Amplification co-efficient - a higher value here means
     *           less tolerance for imbalance within the pool's assets.
     *           Suggested values include:
     *            * Uncollateralized algorithmic stablecoins: 5-10
     *            * Non-redeemable, collateralized assets: 100
     *            * Redeemable assets: 200-400
     * @param _fee Trade fee, given as an integer with 1e10 precision. The
     *             the maximum is 1% (100000000).
     *             50% of the fee is distributed to veCRV holders.
     * @param _offpeg_fee_multiplier Off-peg fee multiplier
     * @param _ma_exp_time Averaging window of oracle. Set as time_in_seconds / ln(2)
     *                     Example: for 10 minute EMA, _ma_exp_time is 600 / ln(2) ~= 866
     * @param _implementation_idx Index of the implementation to use
     * @param _asset_type Asset type for token, as an integer
     * @param _method_id  First four bytes of the Keccak-256 hash of the function signatures
     *                    of the oracle addresses that gives rate oracles.
     *                    Calculated as: keccak(text=event_signature.replace(" ", ""))[:4]
     * @param _oracle Rate oracle address.
     * @return Address of the deployed pool
     */
    function deploy_metapool(
        address _base_pool,
        string memory _name,
        string memory _symbol,
        address _coin,
        uint256 _A,
        uint256 _fee,
        uint256 _offpeg_fee_multiplier,
        uint256 _ma_exp_time,
        uint256 _implementation_idx,
        uint8 _asset_type,
        bytes4 _method_id,
        address _oracle
    )
        external
        returns (address);
    /**
     * @notice Deploy a liquidity gauge for a factory pool
     * @param _pool Factory pool address to deploy a gauge for
     * @return Address of the deployed gauge
     */
    function deploy_gauge(address _pool) external returns (address);

    /**
     * @notice Add a base pool to the registry, which may be used in factory metapools
     * @dev 1. Only callable by admin
     *      2. Rebasing tokens are not allowed in the base pool.
     *      3. Do not add base pool which contains native tokens (e.g. ETH).
     *      4. As much as possible: use standard ERC20 tokens.
     *      Should you choose to deviate from these recommendations, audits are advised.
     * @param _base_pool Pool address to add
     * @param _base_lp_token LP token of the base pool
     * @param _asset_types Asset type for pool, as an integer
     * @param _n_coins Number of coins in the pool
     */
    function add_base_pool(
        address _base_pool,
        address _base_lp_token,
        uint8[] memory _asset_types,
        uint256 _n_coins
    )
        external;

    /**
     * @notice Set implementation contracts for pools
     * @dev Only callable by admin
     * @param _implementation_index Implementation index where implementation is stored
     * @param _implementation Implementation address to use when deploying plain pools
     */
    function set_pool_implementations(uint256 _implementation_index, address _implementation) external;

    /**
     * @notice Set implementation contracts for metapools
     * @dev Only callable by admin
     * @param _implementation_index Implementation index where implementation is stored
     * @param _implementation Implementation address to use when deploying meta pools
     */
    function set_metapool_implementations(uint256 _implementation_index, address _implementation) external;

    /**
     * @notice Set implementation contracts for StableSwap Math
     * @dev Only callable by admin
     * @param _math_implementation Address of the math implementation contract
     */
    function set_math_implementation(address _math_implementation) external;

    /**
     * @notice Set implementation contracts for liquidity gauge
     * @dev Only callable by admin
     * @param _gauge_implementation Address of the gauge blueprint implementation contract
     */
    function set_gauge_implementation(address _gauge_implementation) external;

    /**
     * @notice Set implementation contracts for Views methods
     * @dev Only callable by admin
     * @param _views_implementation Implementation address of views contract
     */
    function set_views_implementation(address _views_implementation) external;
}
