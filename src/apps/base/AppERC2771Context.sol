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
// Originally sourced from OpenZeppelin Contracts (last updated v4.9.3) (metatx/ERC2771Context.sol)
pragma solidity >=0.8.21;

import { AppBase } from "src/apps/base/AppBase.sol";
import { IBaseModule } from "src/interfaces/accounts/IBaseModule.sol";

/**
 * @dev Context variant with ERC2771 support.
 */
library AppERC2771Context {
    function _msgSender() internal view returns (address) {
        uint256 calldataLength = msg.data.length;
        uint256 contextSuffixLength = _contextSuffixLength();
        if (_isTrustedForwarder(msg.sender) && calldataLength >= contextSuffixLength) {
            return address(bytes20(msg.data[calldataLength - contextSuffixLength:]));
        } else {
            return msg.sender;
        }
    }

    // slither-disable-start dead-code
    function _msgData() internal view returns (bytes calldata) {
        uint256 calldataLength = msg.data.length;
        uint256 contextSuffixLength = _contextSuffixLength();
        if (_isTrustedForwarder(msg.sender) && calldataLength >= contextSuffixLength) {
            return msg.data[:calldataLength - contextSuffixLength];
        } else {
            return msg.data;
        }
    }

    /**
     * @notice Checks if a forwarder is trusted.
     * @param forwarder The address of the forwarder to check.
     * @return A boolean indicating whether the forwarder is trusted or not.
     */
    function _isTrustedForwarder(address forwarder) internal view returns (bool) {
        return IBaseModule(AppBase._getMainAccount()).isTrustedForwarder(forwarder);
    }

    /**
     * @dev ERC-2771 specifies the context as being a single address (20 bytes).
     */
    function _contextSuffixLength() internal pure returns (uint256) {
        return 20;
    }
    // slither-disable-end dead-code
}
