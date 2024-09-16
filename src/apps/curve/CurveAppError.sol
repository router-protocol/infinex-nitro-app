// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

library CurveAppError {
    /*///////////////////////////////////////////////////////////////
                                GENERIC
    ///////////////////////////////////////////////////////////////*/

    error TokenIndexMismatch();
    error InvalidPoolAddress(address poolAddress);
    error UnsupportedPool(address poolAddress);
    error InvalidToken();
    error ZeroAddress();
}
