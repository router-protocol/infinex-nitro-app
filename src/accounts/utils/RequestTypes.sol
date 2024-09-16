// SPDX-License-Identifier: MIT
pragma solidity >=0.8.21;

contract RequestTypes {
    struct Request {
        address _address;
        address _address2;
        uint256 _uint256;
        bytes32 _nonce;
        uint32 _uint32;
        bool _bool;
        bytes4 _selector;
    }
}
