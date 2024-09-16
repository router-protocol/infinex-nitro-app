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

import { Error } from "src/libraries/Error.sol";

/**
 * @title AppBase storage struct
 */
library AppBase {
    struct Data {
        address mainAccount; // main account address
        address appBeacon; // Address of beacon for app configuration
    }

    /*///////////////////////////////////////////////////////////////
                    			EVENTS / ERRORS
    ///////////////////////////////////////////////////////////////*/

    event MainAccountSet(address mainAccount);
    event AppBeaconSet(address appBeacon);

    /**
     * @dev Returns the account stored at the specified account id.
     */
    function getStorage() internal pure returns (Data storage data) {
        bytes32 s = keccak256(abi.encode("io.infinex.AppBase"));
        assembly {
            data.slot := s
        }
    }

    /*///////////////////////////////////////////////////////////////
                                VIEW FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Get the Main Account.
     * @return The Main Account address.
     */
    function _getMainAccount() internal view returns (address) {
        Data storage data = getStorage();
        return data.mainAccount;
    }

    /**
     * @notice Get the App Beacon.
     * @return The App Beacon.
     */
    function _getAppBeacon() internal view returns (address) {
        Data storage data = getStorage();
        return data.appBeacon;
    }

    /*///////////////////////////////////////////////////////////////
                                MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Set the Main Account address.
     * @param _mainAccount The address to be set as Main Account.
     */
    function _setMainAccount(address _mainAccount) internal {
        Data storage data = getStorage();
        if (_mainAccount == address(0)) revert Error.NullAddress();
        emit MainAccountSet(_mainAccount);
        data.mainAccount = _mainAccount;
    }

    /**
     * @notice Set an app beacon for the account.
     * @param _appBeacon The app beacon associated with the account.
     */
    function _setAppBeacon(address _appBeacon) internal {
        Data storage data = getStorage();
        if (_appBeacon == address(0)) revert Error.NullAddress();
        emit AppBeaconSet(_appBeacon);
        data.appBeacon = _appBeacon;
    }
}
