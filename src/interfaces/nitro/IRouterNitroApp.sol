// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

import { IRouterNitroGateway } from "../nitro/IRouterNitroGateway.sol";

/**
 * @title IRouterNitroApp
 * @dev Interface for handler contracts that support deposits and deposit executions.
 */
interface IRouterNitroApp {
    /**
     * @dev Bridge assets from the source chain to the destination chain.
     * @param depositData The deposit data containing the necessary information for the bridge transaction.
     * @param destToken The destination token address.
     * @param recipient The recipient address on the destination chain.
     */
    function bridgeAssets(
        IRouterNitroGateway.DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient
    )
        external
        payable;

    /**
     * @dev Update the bridge transaction data.
     * @param srcToken The source token address.
     * @param feeAmount The fee amount for the bridge transaction.
     * @param depositId The deposit ID.
     * @param initiatewithdrawal Flag indicating whether to initiate a withdrawal on the destination chain.
     */
    function updateBridgeTxnData(
        address srcToken,
        uint256 feeAmount,
        uint256 depositId,
        bool initiatewithdrawal
    )
        external
        payable;

    /**
     * @dev Bridge assets from the source chain to the destination chain with a message.
     * @param depositData The deposit data containing the necessary information for the bridge transaction.
     * @param destToken The destination token address.
     * @param recipient The recipient address on the destination chain.
     * @param message The message to include in the bridge transaction.
     */
    function bridgeAssetsWithMessage(
        IRouterNitroGateway.DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient,
        bytes memory message
    )
        external
        payable;
}
