// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/// @title Interface for handler contracts that support deposits and deposit executions.
/// @author Router Protocol.
interface IRouterNitroGateway {
    /**
     * @dev Emitted when funds are deposited.
     * @param partnerId The ID of the partner.
     * @param amount The amount of funds deposited.
     * @param destChainIdBytes The destination chain ID.
     * @param destAmount The amount of funds on the destination chain.
     * @param depositId The ID of the deposit.
     * @param srcToken The address of the source token.
     * @param depositor The address of the depositor.
     * @param recipient The recipient of the funds.
     * @param destToken The address of the destination token.
     */
    event FundsDeposited(
        uint256 partnerId,
        uint256 amount,
        bytes32 destChainIdBytes,
        uint256 destAmount,
        uint256 depositId,
        address srcToken,
        address depositor,
        bytes recipient,
        bytes destToken
    );

    /**
     * @dev Emitted when iUSDC is deposited.
     * @param partnerId The ID of the partner.
     * @param amount The amount of iUSDC deposited.
     * @param destChainIdBytes The destination chain ID.
     * @param usdcNonce The nonce of the iUSDC deposit.
     * @param srcToken The address of the source token.
     * @param recipient The recipient of the funds.
     * @param depositor The address of the depositor.
     */
    event iUSDCDeposited(
        uint256 partnerId,
        uint256 amount,
        bytes32 destChainIdBytes,
        uint256 usdcNonce,
        address srcToken,
        bytes32 recipient,
        address depositor
    );

    /**
     * @dev Emitted when funds are deposited with a message.
     * @param partnerId The ID of the partner.
     * @param amount The amount of funds deposited.
     * @param destChainIdBytes The destination chain ID.
     * @param destAmount The amount of funds on the destination chain.
     * @param depositId The ID of the deposit.
     * @param srcToken The address of the source token.
     * @param recipient The recipient of the funds.
     * @param depositor The address of the depositor.
     * @param destToken The address of the destination token.
     * @param message The message associated with the deposit.
     */
    event FundsDepositedWithMessage(
        uint256 partnerId,
        uint256 amount,
        bytes32 destChainIdBytes,
        uint256 destAmount,
        uint256 depositId,
        address srcToken,
        bytes recipient,
        address depositor,
        bytes destToken,
        bytes message
    );

    /**
     * @dev Emitted when funds are paid.
     * @param messageHash The hash of the message.
     * @param forwarder The address of the forwarder.
     * @param nonce The nonce of the payment.
     */
    event FundsPaid(bytes32 messageHash, address forwarder, uint256 nonce);

    /**
     * @dev Emitted when deposit information is updated.
     * @param srcToken The address of the source token.
     * @param feeAmount The amount of the fee.
     * @param depositId The ID of the deposit.
     * @param eventNonce The nonce of the event.
     * @param initiatewithdrawal Flag indicating if withdrawal should be initiated.
     * @param depositor The address of the depositor.
     */
    event DepositInfoUpdate(
        address srcToken,
        uint256 feeAmount,
        uint256 depositId,
        uint256 eventNonce,
        bool initiatewithdrawal,
        address depositor
    );

    /**
     * @dev Emitted when funds are paid with a message.
     * @param messageHash The hash of the message.
     * @param forwarder The address of the forwarder.
     * @param nonce The nonce of the payment.
     * @param execFlag Flag indicating if execution should be performed.
     * @param execData The execution data.
     */
    event FundsPaidWithMessage(bytes32 messageHash, address forwarder, uint256 nonce, bool execFlag, bytes execData);

    /**
     * @dev Struct representing the destination details.
     * @param domainId The ID of the domain.
     * @param fee The fee amount.
     * @param isSet Flag indicating if the destination is set.
     */
    struct DestDetails {
        uint32 domainId;
        uint256 fee;
        bool isSet;
    }

    /**
     * @dev Struct representing the relay data.
     * @param amount The amount of funds.
     * @param srcChainId The source chain ID.
     * @param depositId The ID of the deposit.
     * @param destToken The address of the destination token.
     * @param recipient The recipient of the funds.
     */
    struct RelayData {
        uint256 amount;
        bytes32 srcChainId;
        uint256 depositId;
        address destToken;
        address recipient;
    }

    /**
     * @dev Struct representing the relay data with a message.
     * @param amount The amount of funds.
     * @param srcChainId The source chain ID.
     * @param depositId The ID of the deposit.
     * @param destToken The address of the destination token.
     * @param recipient The recipient of the funds.
     * @param message The message associated with the relay.
     */
    struct RelayDataMessage {
        uint256 amount;
        bytes32 srcChainId;
        uint256 depositId;
        address destToken;
        address recipient;
        bytes message;
    }

    /**
     * @dev Struct representing the deposit data.
     * @param partnerId The ID of the partner.
     * @param amount The amount of funds.
     * @param destAmount The amount of funds on the destination chain.
     * @param srcToken The address of the source token.
     * @param refundRecipient The recipient of the refund.
     * @param destChainIdBytes The destination chain ID.
     */
    struct DepositData {
        uint256 partnerId;
        uint256 amount;
        uint256 destAmount;
        address srcToken;
        address refundRecipient;
        bytes32 destChainIdBytes;
    }

    /**
     * @dev Struct representing the transfer payload.
     * @param destChainIdBytes The destination chain ID.
     * @param srcTokenAddress The address of the source token.
     * @param srcTokenAmount The amount of the source token.
     * @param recipient The recipient of the funds.
     * @param partnerId The ID of the partner.
     */
    struct TransferPayload {
        bytes32 destChainIdBytes;
        address srcTokenAddress;
        uint256 srcTokenAmount;
        bytes recipient;
        uint256 partnerId;
    }

    /**
     * @dev Deposits iUSDC.
     * @param partnerId The ID of the partner.
     * @param destChainIdBytes The destination chain ID.
     * @param recipient The recipient of the funds.
     * @param amount The amount of iUSDC to deposit.
     */
    function iDepositUSDC(
        uint256 partnerId,
        bytes32 destChainIdBytes,
        bytes32 recipient,
        uint256 amount
    )
        external
        payable;

    /**
     * @dev Deposits funds.
     * @param depositData The deposit data.
     * @param destToken The address of the destination token.
     * @param recipient The recipient of the funds.
     */
    function iDeposit(
        DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient
    )
        external
        payable;

    /**
     * @dev Updates deposit information.
     * @param srcToken The address of the source token.
     * @param feeAmount The amount of the fee.
     * @param depositId The ID of the deposit.
     * @param initiatewithdrawal Flag indicating if withdrawal should be initiated.
     */
    function iDepositInfoUpdate(
        address srcToken,
        uint256 feeAmount,
        uint256 depositId,
        bool initiatewithdrawal
    )
        external
        payable;

    /**
     * @dev Deposits funds with a message.
     * @param depositData The deposit data.
     * @param destToken The address of the destination token.
     * @param recipient The recipient of the funds.
     * @param message The message associated with the deposit.
     */
    function iDepositMessage(
        DepositData memory depositData,
        bytes memory destToken,
        bytes memory recipient,
        bytes memory message
    )
        external
        payable;

    /**
     * @dev Relays funds.
     * @param relayData The relay data.
     */
    function iRelay(RelayData memory relayData) external payable;

    /**
     * @dev Returns the deposit nonce.
     * @return The deposit nonce.
     */
    function depositNonce() external view returns (uint256);

    /**
     * @dev Relays funds with a message.
     * @param relayData The relay data.
     */
    function iRelayMessage(RelayDataMessage memory relayData) external payable;

    /**
     * @dev Transfers tokens.
     * @param transferPayload The transfer payload.
     */
    function transferToken(TransferPayload memory transferPayload) external payable;

    /**
     * @dev Transfers tokens with instruction.
     * @param transferPayload The transfer payload.
     * @param destGasLimit The destination gas limit.
     * @param instruction The instruction data.
     */
    function transferTokenWithInstruction(
        TransferPayload memory transferPayload,
        uint64 destGasLimit,
        bytes calldata instruction
    )
        external
        payable;
}
