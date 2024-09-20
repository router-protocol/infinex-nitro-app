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

// Importing the base class for application beacons
import { AppBeaconBase } from "src/apps/base/AppBeaconBase.sol";

/**
 * @title RouterNitroAppBeacon
 * @dev This contract extends AppBeaconBase to provide a beacon for the RouterNitro application.
 * The beacon points to the latest implementation of the application and stores addresses for the RouterNitroGateway and
 * RouterAssetBridgeGateway.
 */
contract RouterNitroAppBeacon is AppBeaconBase {
    // Address of the RouterNitroGateway contract
    address public immutable routerNitroGateway;
    // Address of the RouterAssetBridgeGateway contract
    address public immutable routerAssetBridgeGateway;

    /**
     * @dev Constructs a new RouterNitroAppBeacon contract.
     * @param _owner The owner of the contract.
     * @param _latestAppImplementation The address of the latest implementation of the RouterNitro application.
     * @param _routerNitroGateway The address of the RouterNitroGateway contract.
     * @param _routerAssetBridgeGateway The address of the RouterAssetBridgeGateway contract.
     */
    constructor(
        address _owner,
        address _latestAppImplementation,
        address _routerNitroGateway,
        address _routerAssetBridgeGateway
    )
        // Call the constructor of the base class
        AppBeaconBase(_owner, _latestAppImplementation, "RouterNitro")
    {
        // Initialize the RouterNitroGateway and RouterAssetBridgeGateway addresses
        routerNitroGateway = _routerNitroGateway;
        routerAssetBridgeGateway = _routerAssetBridgeGateway;
    }
}
