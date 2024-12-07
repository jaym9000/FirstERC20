// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        _mint(msg.sender, initialSupply);
    }

    //  // Helper functions to increase and decrease allowances
    // function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
    //     _approve(msg.sender, spender, allowance(msg.sender, spender) + addedValue);
    //     return true;
    // }

    // function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
    //     uint256 currentAllowance = allowance(msg.sender, spender);
    //     require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
    //     _approve(msg.sender, spender, currentAllowance - subtractedValue);
    //     return true;
    // }
}
