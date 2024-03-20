// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import {ERC20} from "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./fundme.sol";

//让 FundMe的参与者，基于 mapping来领取相应数量的 token
contract FundTokenERC20 is ERC20 {
    FundMe fundMe;

    constructor(address addr) ERC20("FundTokenERC20", "FT") {
        fundMe = FundMe(addr);
    }

    function mint(uint256 amountMint) public {
        require(
            fundMe.fundersToAmount(msg.sender) >= amountMint,
            "You cann't mint this many tokens"
        );
        require(fundMe.getFundSuccess(),"The fundme is not completed yet");
        _mint(msg.sender, amountMint);
        fundMe.setFundertoAmount(msg.sender, fundMe.fundersToAmount(msg.sender) - amountMint);
    }

    function claim(uint256 amountToBurn) public {
        require(balanceOf(msg.sender)>=amountToBurn, "You don't have enough ERC20 tokens");
        _burn(msg.sender, amountToBurn);
    }
}
