// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

interface GravityBridge {
    function sendToCosmos(address _tokenContract, string memory _destination, uint _amount) external;
}

interface WETH {
    function deposit() external payable;

    function approve(address guy, uint wad) external returns (bool);
}

/**
 * @notice This contract is a router to send ETH to Cosmos using gravity bridge
 */
contract SendEthToCosmos {
    GravityBridge gravityBridge = GravityBridge(0xa4108aA1Ec4967F8b52220a4f7e94A8201F2D906);
    WETH weth = WETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    constructor() {
        // approve gravity bridge to spend WETH to save gas later
        weth.approve(address(gravityBridge), type(uint256).max);
    }

    function sendToCosmos(string memory _destination) external payable {
        weth.deposit{value: msg.value}();
        gravityBridge.sendToCosmos(address(weth), _destination, msg.value);
    }
}
