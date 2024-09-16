// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { IRouterNitroGateway } from "../nitro/IRouterNitroGateway.sol";

/// @title Interface for handler contracts that support deposits and deposit executions.
/// @author Router Protocol.
interface IRouterNitroApp {
    function bridgeAssets(
        IRouterNitroGateway.DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient
    )
        external
        payable;

    function updateBridgeTxnData(
        address srcToken,
        uint256 feeAmount,
        uint256 depositId,
        bool initiatewithdrawal
    )
        external
        payable;

    function bridgeAssetsWithMessage(
        IRouterNitroGateway.DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient,
        bytes memory message
    )
        external
        payable;
}
