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

import { AppERC2771Context } from "src/apps/base/AppERC2771Context.sol";
import { AppBase } from "src/apps/base/AppBase.sol";

import { IAccountUtilsModule } from "src/interfaces/accounts/IAccountUtilsModule.sol";

contract AppSecurityModifiers {
    /*///////////////////////////////////////////////////////////////
                                ERRORS
    ///////////////////////////////////////////////////////////////*/

    error InvalidKeySignature(address from);

    /*///////////////////////////////////////////////////////////////
                            SECURITY CHECK MODIFIERS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Modifier to check if the sender is the main account.
     */
    modifier requiresMainAccountSender() {
        if (msg.sender != AppBase._getMainAccount()) {
            revert InvalidKeySignature(msg.sender);
        }

        _;
    }

    /**
     * @notice Modifier to check if the sender is an sudo key.
     */
    modifier requiresSudoKeySender() {
        if (!_isValidSudoKey(AppERC2771Context._msgSender())) {
            revert InvalidKeySignature(AppERC2771Context._msgSender());
        }

        _;
    }

    /**
     * @notice Modifier to check if the sender is a sudo or operation key.
     * If not, it reverts with an error message.
     */
    modifier requiresAuthorizedOperationsParty() {
        if (!_isAuthorizedOperationsParty(AppERC2771Context._msgSender())) {
            revert InvalidKeySignature(AppERC2771Context._msgSender());
        }

        _;
    }

    /**
     * @notice Modifier to check if the sender is an sudo key, a recovery key or a trusted recovery keeper.
     * If not, it reverts with an error message.
     */
    modifier requiresAuthorizedRecoveryParty() {
        if (!_isAuthorizedRecoveryParty(AppERC2771Context._msgSender())) {
            revert InvalidKeySignature(AppERC2771Context._msgSender());
        }

        _;
    }

    /**
     * @notice Validate with the parent account if a key is a sudoKey.
     * @param _key The key to check.
     */
    function _isValidSudoKey(address _key) internal view returns (bool) {
        return IAccountUtilsModule(AppBase._getMainAccount()).isValidSudoKey(_key);
    }

    /**
     * @notice Validate with the parent account if a key is an authorized operations party.
     * @param _key The key to check.
     */
    function _isAuthorizedOperationsParty(address _key) internal view returns (bool) {
        return IAccountUtilsModule(AppBase._getMainAccount()).isAuthorizedOperationsParty(_key);
    }

    /**
     * @notice Validate with the parent account if a key is an authorized recovery party.
     * @param _key The key to check.
     */
    function _isAuthorizedRecoveryParty(address _key) internal view returns (bool) {
        return IAccountUtilsModule(AppBase._getMainAccount()).isAuthorizedRecoveryParty(_key);
    }
}
