// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

abstract contract Parent {
    uint256 public a;
    uint256 private b;
    function addOne() public {
        a++;
    }

    function add() public virtual;
}

contract Child is Parent {
    function addTwo() public {
        a += 2;
    }

    function add() public override {

    }
}
