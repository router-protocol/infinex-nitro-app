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

import { Ownable2Step, Ownable } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/ERC165.sol";

import { IAppAccountBase } from "src/interfaces/apps/base/IAppAccountBase.sol";
import { IAppBeaconBase } from "src/interfaces/apps/base/IAppBeaconBase.sol";

abstract contract AppBeaconBase is IAppBeaconBase, ERC165, Ownable2Step {
    address public immutable APP_IMPLEMENTATION;
    AppBeaconConfig public appBeaconConfig;

    constructor(address _owner, address _appImplementation, string memory _appName) Ownable(_owner) {
        appBeaconConfig.appName = _appName;
        if (!IERC165(_appImplementation).supportsInterface(type(IAppAccountBase).interfaceId)) {
            revert InvalidAppAccountImplementation();
        }
        APP_IMPLEMENTATION = _appImplementation;
        appBeaconConfig.latestAppBeacon = address(this);
    }

    /*///////////////////////////////////////////////////////////////
                       			VIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165) returns (bool) {
        return interfaceId == type(IAppBeaconBase).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @notice Gets the name of the app associated to the beacon.
     * @return The name of the app beacon.
     */
    function getAppName() external view returns (string memory) {
        return appBeaconConfig.appName;
    }

    /**
     * @notice Gets the latest app implementation.
     * @return The address of the latest app implementation.
     */
    function getLatestAppImplementation() external view returns (address) {
        return APP_IMPLEMENTATION;
    }

    /**
     * @notice Gets the latest beacon address for the app.
     * @return The address of the latest app beacon.
     */
    function getLatestAppBeacon() external view returns (address) {
        return appBeaconConfig.latestAppBeacon;
    }

    /*///////////////////////////////////////////////////////////////
                    		    MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets the latest app beacon address.
     * @param _latestAppBeacon The address of the latest app beacon associated with the app.
     */
    function setLatestAppBeacon(address _latestAppBeacon) external onlyOwner {
        if (_latestAppBeacon == address(0)) revert ZeroAddress();
        emit LatestAppBeaconSet(_latestAppBeacon);
        appBeaconConfig.latestAppBeacon = _latestAppBeacon;
    }
}
