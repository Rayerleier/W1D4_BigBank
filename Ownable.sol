// 题目的意思我没有很理解。按照我的理解，
//BigBank将管理员权限托管给Ownable，Ownable的管理员是实际的管理员，Ownable支持更换管理员，BigBank只接受Ownable的调用。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "Bank.sol";
contract Ownable{
    address private admin;

    constructor() payable {
        admin = msg.sender;
    }

    receive() external payable { }

    fallback() external payable { }
    modifier OnlyAdmin(){
        require(msg.sender == admin, "Ownable:Only Admin manipulate.");
        _;
    }

    // transfer admin
    function transferAdmin(address _newAdmin) public OnlyAdmin{
        admin = _newAdmin;
    }

    function withdraw(address _bigbank,uint256 _amounts) payable public OnlyAdmin {
        IBank(_bigbank).withdraw(_amounts);
    }

}