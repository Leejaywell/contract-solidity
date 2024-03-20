// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {HelloWorld} from "./helloworld.sol";

contract HelloFactory {
    HelloWorld hw;
    HelloWorld[] hws;
    function createHello() public {
        hw = new HelloWorld();
        hws.push(hw);
    }
    
    function getHelloWorldByIndex(uint256 _index) public view returns (HelloWorld) {
        return hws[_index];
    }
}