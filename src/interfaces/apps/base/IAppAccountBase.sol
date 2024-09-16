// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/**
 * @title IAppAccountBase
 * @notice Interface for the App Account Base
 */
interface IAppAccountBase {
    /*///////////////////////////////////////////////////////////////
    	 						EVENTS
    ///////////////////////////////////////////////////////////////*/

    event EtherTransferredToMainAccount(uint256 amount);
    event ERC20TransferredToMainAccount(address indexed token, uint256 amount);
    event ERC721TransferredToMainAccount(address indexed token, uint256 tokenId);
    event ERC1155TransferredToMainAccount(address indexed token, uint256 tokenId, uint256 amount, bytes data);
    event ERC1155BatchTransferredToMainAccount(address indexed token, uint256[] _ids, uint256[] _values, bytes _data);
    event EtherRecoveredToMainAccount(uint256 amount);
    event ERC20RecoveredToMainAccount(address indexed token, uint256 amount);
    event ERC721RecoveredToMainAccount(address indexed token, uint256 tokenId);
    event ERC1155RecoveredToMainAccount(address indexed token, uint256 tokenId, uint256 amount, bytes data);
    event ERC1155BatchRecoveredToMainAccount(address indexed token, uint256[] tokenIds, uint256[] amounts, bytes _data);

    /*///////////////////////////////////////////////////////////////
                                ERRORS
    ///////////////////////////////////////////////////////////////*/

    error SameAddress();
    error InvalidAppBeacon();
    error ImplementationMismatch(address implementation, address latestImplementation);
    error ETHTransferFailed();

    /*///////////////////////////////////////////////////////////////
                                 		INITIALIZER
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Initialize the app account with the main account and the app beacon.
     * @param _mainAccount the address of the main account, this is the owner of the app.
     * @param _appBeacon the beacon for the app account.
     */
    function initialize(address _mainAccount, address _appBeacon) external;

    /*///////////////////////////////////////////////////////////////
                    			VIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Returns the app version number of the app account.
     * @return A uint64 representing the version of the app.
     * @dev NOTE: This number must be updated whenever a new version is deployed.
     * The number should always only be incremented by 1.
     */
    function appVersion() external pure returns (uint64);

    /**
     * @notice Get the app's main account.
     * @return The main account associated with this app.
     */
    function getMainAccount() external view returns (address);

    /**
     * @notice Get the app config beacon.
     * @return The app config beacon address.
     */
    function getAppBeacon() external view returns (address);

    /*///////////////////////////////////////////////////////////////
                    			MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Transfer Ether to the main account from the app account.
     * @param _amount The amount of Ether to transfer.
     */
    function transferEtherToMainAccount(uint256 _amount) external;

    /**
     * @notice Transfer ERC20 tokens to the main account from the app account.
     * @param _token The address of the ERC20 token.
     * @param _amount The amount of tokens to transfer.
     */
    function transferERC20ToMainAccount(address _token, uint256 _amount) external;

    /**
     * @notice Transfer ERC721 tokens to the main account from the app account.
     * @param _token The address of the ERC721 token.
     * @param _tokenId The ID of the ERC721 token.
     */
    function transferERC721ToMainAccount(address _token, uint256 _tokenId) external;

    /**
     * @notice Transfer ERC1155 tokens to the main account from the app account.
     * @param _token The address of the ERC1155 token.
     * @param _tokenId The ID of the ERC1155 token.
     * @param _amount The amount of tokens to transfer.
     * @param _data Data to send with the transfer.
     */
    function transferERC1155ToMainAccount(
        address _token,
        uint256 _tokenId,
        uint256 _amount,
        bytes calldata _data
    )
        external;

    /**
     * @notice Transfers batch ERC1155 tokens to the main account from the app account.
     * @param _token The address of the ERC1155 token.
     * @param _ids The IDs of the ERC1155 tokens.
     * @param _amounts The amounts of the ERC1155 tokens.
     * @param _data Data to send with the transfer.
     */
    function transferERC1155BatchToMainAccount(
        address _token,
        uint256[] calldata _ids,
        uint256[] calldata _amounts,
        bytes calldata _data
    )
        external;

    /**
     * @notice Recovers all ether in the app account to the main account.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverEtherToMainAccount() external;

    /**
     * @notice Recovers the full balance of an ERC20 token to the main account.
     * @param _token The address of the token to be recovered to the main account.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverERC20ToMainAccount(address _token) external;

    /**
     * @notice Recovers a specified ERC721 token to the main account.
     * @param _token The ERC721 token address to recover.
     * @param _tokenId The ID of the ERC721 token to recover.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverERC721ToMainAccount(address _token, uint256 _tokenId) external;

    /**
     * @notice Recovers all the tokens of a specified ERC1155 token to the main account.
     * @param _token The ERC1155 token address to recover.
     * @param _tokenId The id of the token to recover.
     * @param _data The data for the transaction.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverERC1155ToMainAccount(address _token, uint256 _tokenId, bytes calldata _data) external;

    /**
     * @notice Recovers batch ERC1155 tokens to the main account.
     * @param _token The address of the ERC1155 token.
     * @param _ids The IDs of the ERC1155 tokens.
     * @param _values The values of the ERC1155 tokens.
     * @param _data Data to send with the transfer.
     */
    function recoverERC1155BatchToMainAccount(
        address _token,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    )
        external;

    /**
     * @notice Upgrade the app account to the latest implementation and beacon.
     * @param _appBeacon The address of the new app beacon.
     * @dev Requires the sender to be the main account.
     */
    function upgradeAppVersion(address _appBeacon) external;
}
