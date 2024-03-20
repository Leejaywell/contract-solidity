// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract FundToken {
    // 1.通证名字
    // 2.通证的简称
    //3.通证的发行数量
    //4.owner 的地址
    //5.balance address => unit256

    string public tokenName;
    string public tokenSymble;
    uint256 public totalSupply;
    address public owner;
    mapping(address => uint256) public balances;

    constructor(string memory _tokenName, string memory _tokenSymble) {
        tokenName = _tokenName;
        tokenSymble = _tokenSymble;
        owner = msg.sender;
    }

    function mint(uint256 amountToMint) public {
        balances[msg.sender] += amountToMint;
        totalSupply += amountToMint;
    }

    function transfer(address payee, uint256 amount) public {
        require(balances[msg.sender] >= amount, "You do not have enough balance to transfer");
        balances[msg.sender] -= amount;
        balances[payee] += amount;
    }
    
    function balanceOf(address addr) public view returns(uint256) {
        return balances[addr];
    }
}