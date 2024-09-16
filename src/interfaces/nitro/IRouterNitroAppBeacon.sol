// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

/// @title Interface for handler contracts that support deposits and deposit executions.
/// @author Router Protocol.
interface IRouterNitroAppBeacon {
    function routerNitroGateway() external view returns (address);
}
