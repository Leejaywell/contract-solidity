// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 constant MINIMUM_VALUE = 100 * 10 ** 18;

    mapping(address => uint256) public fundersToAmount;

    uint256 constant TARGET = 100 * 10 ** 18;

    uint256 deploymentTimestamp;
    uint256 lockTime;

    AggregatorV3Interface dataFeed;

    address erc20Addr;

    address public owner;

    bool public getFundSuccess;

    constructor(uint256 _lockTime) {
        dataFeed = AggregatorV3Interface(
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
        );
        owner = msg.sender;
        deploymentTimestamp = block.timestamp;
        lockTime = _lockTime;
    }

    function fund() external payable windowCLosed {
        require(
            convertETHTUSD(msg.value) >= MINIMUM_VALUE,
            "please send more eth"
        );
        fundersToAmount[msg.sender] += msg.value;
        getFundSuccess = true;
    }

    /**
     * Returns the latest answer.
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int256) {
        // prettier-ignore
        (
      /* uint80 roundId */
      ,
      int256 answer,
      /*uint256 startedAt*/
      ,
      /*uint256 updatedAt*/
      ,
      /*uint80 answeredInRound*/
    ) = dataFeed.latestRoundData();
        return answer;
    }

    function convertETHTUSD(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = uint256(getChainlinkDataFeedLatestAnswer());
        return (ethAmount * ethPrice) / (10 ** 8);
    }

    function getFund() external {
        require(
            convertETHTUSD(address(this).balance) >= TARGET,
            "Target is not reached"
        );
        require(msg.sender == owner, "this function only call by owner!!");
        //transfer
        // payable(msg.sender).transfer(address(this).balance);
        //send: transfer ETH and return false if failed
        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success, "tx failed");
        //call: transfer ETH with data return value of function and bool
        bool success;
        (success, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(success, "tx failed");
    }

    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "this function only call by owner!!");
        owner = newOwner;
    }

    function setFundertoAmount(
        address funder,
        uint256 amountToUpdate
    ) external {
        fundersToAmount[funder] = amountToUpdate;
    }

    function setErc20Addr(address _erc20Addr) public onlyOwner {
        erc20Addr = _erc20Addr;
    }

    modifier windowCLosed() {
        require(
            deploymentTimestamp + lockTime > block.timestamp,
            "window is closed "
        );
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "this function only call by owner!!");
        _;
    }
}
