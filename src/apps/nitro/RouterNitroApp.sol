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

import { IRouterNitroAppBeacon } from "src/interfaces/nitro/IRouterNitroAppBeacon.sol";
import { IRouterNitroApp } from "src/interfaces/nitro/IRouterNitroApp.sol";
import { IRouterNitroGateway } from "src/interfaces/nitro/IRouterNitroGateway.sol";

contract RouterNitroApp is AppAccountBase, IRouterNitroApp {
    using SafeERC20 for IERC20;

    constructor() {
        _disableInitializers();
    }

    /*///////////////////////////////////////////////////////////////
                    			MUTATIVE FUNCTIONS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @dev This function is used to bridge assets from one network to another.
     * @param depositData The data related to the deposit.
     * @param destToken The destination token address in bytes.
     * @param recipient The recipient address in bytes.
     */
    function bridgeAssets(
        IRouterNitroGateway.DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient
    )
        external
        payable
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        // Get the app beacon instance
        IRouterNitroAppBeacon appBeacon = _getAppBeacon();

        // Get the gateway instance from the app beacon
        IRouterNitroGateway gateway = IRouterNitroGateway(appBeacon.routerNitroGateway());

        // Approve the gateway to spend the source token on behalf of the contract
        IERC20(depositData.srcToken).approve(address(gateway), depositData.amount);

        // Call the deposit function on the gateway
        gateway.iDeposit{ value: msg.value }(depositData, destToken, recipient);
    }

    /**
     * @dev This function is used to bridge mintable assets from one network to another.
     * @param transferPayload The data related to the transfer.
     */
    function bridgeMintableAssets(IRouterNitroGateway.TransferPayload memory transferPayload)
        external
        payable
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        // Get the app beacon instance
        IRouterNitroAppBeacon appBeacon = _getAppBeacon();

        // Get the gateway instance from the app beacon
        IRouterNitroGateway gateway = IRouterNitroGateway(appBeacon.routerAssetBridgeGateway());

        // Approve the gateway to spend the source token on behalf of the contract
        IERC20(transferPayload.srcTokenAddress).approve(address(gateway), transferPayload.srcTokenAmount);

        // Call the transferToken function on the gateway
        gateway.transferToken{ value: msg.value }(transferPayload);
    }

    /**
     * @dev This function is used to update the bridge transaction data.
     * @param srcToken The source token address.
     * @param feeAmount The fee amount.
     * @param depositId The deposit ID.
     * @param initiatewithdrawal A boolean value indicating whether to initiate withdrawal or not.
     */
    function updateBridgeTxnData(
        address srcToken,
        uint256 feeAmount,
        uint256 depositId,
        bool initiatewithdrawal
    )
        external
        payable
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        // Get the app beacon instance
        IRouterNitroAppBeacon appBeacon = _getAppBeacon();

        // Get the gateway instance from the app beacon
        IRouterNitroGateway gateway = IRouterNitroGateway(appBeacon.routerNitroGateway());

        // Approve the gateway to spend the source token on behalf of the contract
        IERC20(srcToken).approve(address(gateway), feeAmount);

        // Call the deposit info update function on the gateway
        gateway.iDepositInfoUpdate{ value: msg.value }(srcToken, feeAmount, depositId, initiatewithdrawal);
    }

    /**
     * @dev This function is used to bridge assets with a message from one network to another.
     * @param depositData The data related to the deposit.
     * @param destToken The destination token address in bytes.
     * @param recipient The recipient address in bytes.
     * @param message The message to be sent along with the transaction.
     */
    function bridgeAssetsWithMessage(
        IRouterNitroGateway.DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient,
        bytes memory message
    )
        external
        payable
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        // Get the app beacon instance
        IRouterNitroAppBeacon appBeacon = _getAppBeacon();

        // Get the gateway instance from the app beacon
        IRouterNitroGateway gateway = IRouterNitroGateway(appBeacon.routerNitroGateway());

        // Approve the gateway to spend the source token on behalf of the contract
        IERC20(depositData.srcToken).approve(address(gateway), depositData.amount);

        // Call the deposit function on the gateway with the message
        gateway.iDepositMessage{ value: msg.value }(depositData, destToken, recipient, message);
    }

    /**
     * @dev This function is used to bridge mintable assets with an instruction from one network to another.
     * @param transferPayload The data related to the transfer.
     * @param destGasLimit The destination gas limit.
     * @param instruction The instruction to be sent along with the transaction.
     */
    function bridgeMintableAssetsWithInstruction(
        IRouterNitroGateway.TransferPayload memory transferPayload,
        uint64 destGasLimit,
        bytes calldata instruction
    )
        external
        payable
        nonReentrant
        requiresAuthorizedOperationsParty
    {
        // Get the app beacon instance
        IRouterNitroAppBeacon appBeacon = _getAppBeacon();

        // Get the gateway instance from the app beacon
        IRouterNitroGateway gateway = IRouterNitroGateway(appBeacon.routerAssetBridgeGateway());

        // Approve the gateway to spend the source token on behalf of the contract
        IERC20(transferPayload.srcTokenAddress).approve(address(gateway), transferPayload.srcTokenAmount);

        // Call the transferTokenWithInstruction function on the gateway
        gateway.transferTokenWithInstruction{ value: msg.value }(transferPayload, destGasLimit, instruction);
    }

    /**
     * @dev Returns the beacon contract for the Curve StableSwap app.
     * @return The beacon contract for the Curve StableSwap app.
     */
    function _getAppBeacon() internal view returns (IRouterNitroAppBeacon) {
        return (IRouterNitroAppBeacon(AppBase._getAppBeacon()));
    }
}
