// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract HelloWorld {
    struct Info {
        string phrase;
        uint256 id;
        address addr;
    }

    string str = "Hello World";
    Info[] infos;
    mapping(uint256 id => Info info) infomapping;
    function sayHello(uint256 _id) public view returns(string memory) {
        if(infomapping[_id].addr == address(0x0)) {
            return addinfo(str);
        }
        return infomapping[_id].phrase;
    }

    function setHello(string memory newStr, uint256 _id) public {
        str = newStr;
        Info memory info = Info(str, _id, msg.sender);
        infomapping[_id] = info;
    }

    function addinfo(string memory hellostr) internal pure returns(string memory) {
        return string.concat(hellostr, " from Lee's contract");
    }
}