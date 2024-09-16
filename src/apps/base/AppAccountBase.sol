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

import { ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import { ERC721Holder } from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import { ERC1155Holder } from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import { ReentrancyGuardUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { IUUPSImplementation } from "@synthetixio/core-contracts/contracts/interfaces/IUUPSImplementation.sol";
import { UUPSImplementation } from "@synthetixio/core-contracts/contracts/proxy/UUPSImplementation.sol";

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

import { IAppAccountBase } from "src/interfaces/apps/base/IAppAccountBase.sol";
import { IAppBeaconBase } from "src/interfaces/apps/base/IAppBeaconBase.sol";

import { AppBase } from "src/apps/base/AppBase.sol";
import { AppSecurityModifiers } from "src/apps/base/AppSecurityModifiers.sol";

abstract contract AppAccountBase is
    IAppAccountBase,
    UUPSImplementation,
    AppSecurityModifiers,
    ERC165,
    ERC721Holder,
    ERC1155Holder,
    ReentrancyGuardUpgradeable
{
    /*///////////////////////////////////////////////////////////////
                                FALLBACK
    ///////////////////////////////////////////////////////////////*/

    receive() external payable { }

    /*///////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    ///////////////////////////////////////////////////////////////*/

    constructor() {
        _disableInitializers();
    }

    /*///////////////////////////////////////////////////////////////
                                INITIALIZER
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Initialize the app account with the main account and the app beacon.
     * @param _mainAccount the address of the main account, this is the owner of the app.
     * @param _appBeacon the beacon for the app account.
     */
    function initialize(address _mainAccount, address _appBeacon) external virtual initializer {
        AppBase._setMainAccount(_mainAccount);
        if (!IERC165(_appBeacon).supportsInterface(type(IAppBeaconBase).interfaceId)) {
            revert InvalidAppBeacon();
        }
        AppBase._setAppBeacon(_appBeacon);
    }

    /*///////////////////////////////////////////////////////////////
                                VIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, ERC1155Holder) returns (bool) {
        return interfaceId == type(IAppAccountBase).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @notice Returns the app version number of the app account.
     * @return A uint64 representing the version of the app.
     * @dev NOTE: This number must be updated whenever a new version is deployed.
     * The number should always only be incremented by 1.
     */
    function appVersion() public pure virtual returns (uint64) {
        return 1;
    }

    /**
     * @notice Get the app's main account.
     * @return The main account associated with this app.
     */
    function getMainAccount() external view returns (address) {
        return AppBase._getMainAccount();
    }

    /**
     * @notice Get the app config beacon.
     * @return The app config beacon address.
     */
    function getAppBeacon() external view returns (address) {
        return AppBase._getAppBeacon();
    }

    /*///////////////////////////////////////////////////////////////
                            MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Transfer Ether to the main account from the app account.
     * @param _amount The amount of Ether to transfer.
     */
    function transferEtherToMainAccount(uint256 _amount) external nonReentrant requiresAuthorizedOperationsParty {
        _transferEtherToMainAccount(_amount);
    }

    /**
     * @notice Transfer ERC20 tokens to the main account from the app account.
     * @param _token The address of the ERC20 token.
     * @param _amount The amount of tokens to transfer.
     */
    function transferERC20ToMainAccount(
        address _token,
        uint256 _amount
    )
        external
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        _transferERC20ToMainAccount(_token, _amount);
    }

    /**
     * @notice Transfer ERC721 tokens to the main account from the app account.
     * @param _token The address of the ERC721 token.
     * @param _tokenId The token ID to transfer.
     */
    function transferERC721ToMainAccount(
        address _token,
        uint256 _tokenId
    )
        external
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        _transferERC721ToMainAccount(_token, _tokenId);
    }

    /**
     * @notice Transfer ERC1155 tokens to the main account from the app account.
     * @param _token The address of the ERC1155 token.
     * @param _tokenId The token ID to transfer.
     * @param _amount The amount of tokens to transfer.
     * @param _data Additional data to pass in the transfer.
     */
    function transferERC1155ToMainAccount(
        address _token,
        uint256 _tokenId,
        uint256 _amount,
        bytes calldata _data
    )
        external
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        _transferERC1155ToMainAccount(_token, _tokenId, _amount, _data);
    }

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
        external
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        _transferERC1155BatchToMainAccount(_token, _ids, _amounts, _data);
    }

    /**
     * @notice Recovers all ether in the app account to the main account.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverEtherToMainAccount() external requiresAuthorizedRecoveryParty nonReentrant {
        emit EtherRecoveredToMainAccount(address(this).balance);
        _transferEtherToMainAccount(address(this).balance);
    }

    /**
     * @notice Recovers the full balance of an ERC20 token to the main account.
     * @param _token The address of the token to be recovered to the main account.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverERC20ToMainAccount(address _token) public nonReentrant requiresAuthorizedRecoveryParty {
        uint256 balance = IERC20(_token).balanceOf(address(this));
        emit ERC20RecoveredToMainAccount(_token, balance);
        _transferERC20ToMainAccount(_token, balance);
    }

    /**
     * @notice Recovers a specified ERC721 token to the main account.
     * @param _token The ERC721 token address to recover.
     * @param _tokenId The ID of the ERC721 token to recover.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverERC721ToMainAccount(
        address _token,
        uint256 _tokenId
    )
        external
        requiresAuthorizedRecoveryParty
        nonReentrant
    {
        emit ERC721RecoveredToMainAccount(_token, _tokenId);
        _transferERC721ToMainAccount(_token, _tokenId);
    }

    /**
     * @notice Recovers a specified ERC1155 token to the main account.
     * @param _token The ERC1155 token address to recover.
     * @param _tokenId The id of the token to recover.
     * @param _data The data for the transaction.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverERC1155ToMainAccount(
        address _token,
        uint256 _tokenId,
        bytes calldata _data
    )
        external
        requiresAuthorizedRecoveryParty
        nonReentrant
    {
        uint256 balance = IERC1155(_token).balanceOf(address(this), _tokenId);
        emit ERC1155RecoveredToMainAccount(_token, _tokenId, balance, _data);
        _transferERC1155ToMainAccount(_token, _tokenId, balance, _data);
    }

    /**
     * @notice Recovers multiple ERC1155 tokens to the main account.
     * @param _token The address of the ERC1155 token.
     * @param _tokenIds The IDs of the ERC1155 tokens.
     * @param _amounts The values of the ERC1155 tokens.
     * @param _data Data to send with the transfer.
     * @dev Requires the sender to be an authorized recovery party.
     */
    function recoverERC1155BatchToMainAccount(
        address _token,
        uint256[] calldata _tokenIds,
        uint256[] calldata _amounts,
        bytes calldata _data
    )
        external
        requiresAuthorizedRecoveryParty
        nonReentrant
    {
        emit ERC1155BatchRecoveredToMainAccount(_token, _tokenIds, _amounts, _data);
        _transferERC1155BatchToMainAccount(_token, _tokenIds, _amounts, _data);
    }

    /**
     * @notice Upgrade to a new account implementation
     * @param _newImplementation The address of the new account implementation
     * @dev when this function is called, the UUPSImplementation contract will do
     * a simulation of the upgrade. If the simulation fails, the upgrade will not be performed.
     * So when simulatingUpgrade is true, we bypass the security logic as the way the simulation is
     * done would always revert.
     * @dev NOTE: DO NOT CALL THIS FUNCTION DIRECTLY. USE upgradeAppVersion INSTEAD.
     */
    function upgradeTo(address _newImplementation) public {
        /// @dev if we are in the middle of a simulation, then we use the default _upgradeTo function
        if (_proxyStore().simulatingUpgrade) {
            _upgradeTo(_newImplementation);
            return;
        }
    }

    /**
     * @notice Upgrade the app account to a new app beacon and its implementation.
     * @param _appBeacon The address of the new app beacon.
     * @dev Requires the sender to be the main account.
     * If the new app beacon has the same implementation as the current one, then no upgrade is performed.
     */
    function upgradeAppVersion(address _appBeacon) external requiresMainAccountSender {
        if (_appBeacon == AppBase._getAppBeacon()) {
            revert SameAddress();
        }

        AppBase._setAppBeacon(_appBeacon);
        address latestAppImplementation = IAppBeaconBase(_appBeacon).getLatestAppImplementation();
        if (latestAppImplementation != IUUPSImplementation(address(this)).getImplementation()) {
            _upgradeToLatestImplementation(latestAppImplementation);
        }
    }

    /*///////////////////////////////////////////////////////////////
                                INTERNAL FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Upgrade the account implementation to the latest version
     * @dev Checks are done in the main account
     * @dev requires the sender to be the main account
     * This is marked as virtual so that it can be overridden by an app implementation to perform migration steps
     */
    function _upgradeToLatestImplementation(address _newImplementation) internal virtual {
        _upgradeTo(_newImplementation);
    }

    /**
     * @notice Transfer Ether to the main account from the app account.
     * @param _amount The amount of Ether to transfer.
     */
    function _transferEtherToMainAccount(uint256 _amount) internal {
        emit EtherTransferredToMainAccount(_amount);
        (bool success,) = payable(AppBase._getMainAccount()).call{ value: _amount }("");
        if (!success) revert ETHTransferFailed();
    }

    /**
     * @notice Transfer ERC20 tokens to the main account from the app account.
     * @param _token The address of the ERC20 token.
     * @param _amount The amount of tokens to transfer.
     */
    function _transferERC20ToMainAccount(address _token, uint256 _amount) internal {
        emit ERC20TransferredToMainAccount(_token, _amount);
        SafeERC20.safeTransfer(IERC20(_token), AppBase._getMainAccount(), _amount);
    }

    /**
     * @notice Transfer ERC721 tokens to the main account from the app account.
     * @param _token The address of the ERC721 token.
     * @param _tokenId The token ID to transfer.
     */
    function _transferERC721ToMainAccount(address _token, uint256 _tokenId) internal {
        emit ERC721TransferredToMainAccount(_token, _tokenId);
        IERC721(_token).safeTransferFrom(address(this), AppBase._getMainAccount(), _tokenId);
    }

    /**
     * @notice Transfer ERC1155 tokens to the main account from the app account.
     * @param _token The address of the ERC1155 token.
     * @param _tokenId The token ID to transfer.
     * @param _amount The amount of tokens to transfer.
     * @param _data Additional data to pass in the transfer.
     */
    function _transferERC1155ToMainAccount(
        address _token,
        uint256 _tokenId,
        uint256 _amount,
        bytes calldata _data
    )
        internal
    {
        emit ERC1155TransferredToMainAccount(_token, _tokenId, _amount, _data);
        IERC1155(_token).safeTransferFrom(address(this), AppBase._getMainAccount(), _tokenId, _amount, _data);
    }

    /**
     * @notice Transfers multiple ERC1155 tokens to the main account from the app account.
     * @param _token The address of the ERC1155 token.
     * @param _tokenIds The IDs of the ERC1155 token.
     * @param _amounts The amounts of tokens to transfer.
     * @param _data Data to send with the transfer.
     */
    function _transferERC1155BatchToMainAccount(
        address _token,
        uint256[] calldata _tokenIds,
        uint256[] calldata _amounts,
        bytes calldata _data
    )
        internal
    {
        emit ERC1155BatchTransferredToMainAccount(_token, _tokenIds, _amounts, _data);
        IERC1155(_token).safeBatchTransferFrom(address(this), AppBase._getMainAccount(), _tokenIds, _amounts, _data);
    }
}
