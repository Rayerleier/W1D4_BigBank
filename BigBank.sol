// Write a Bank contract to achieve the following functionalities:

// Allow deposit to the Bank contract address directly through wallets like Metamask
// Keep track of the deposit amount for each address in the Bank contract
// Implement a withdraw() method that allows only the administrator to withdraw funds
// Use an array to record the deposit amounts for the top 3 users
// Please submit the completed project code or the GitHub repository address.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IBank {
    function withdraw(uint256 _amount)external payable ;
    }

contract Bank{
    address internal  admin;
    mapping (address => uint256) internal amounts;
    address [3]  internal   top3;

    constructor() payable {
        admin = msg.sender;
    }

    modifier OnlyAdmin(){
        require(msg.sender == admin, "Only Admin manipulate.");
        _;
    }

    // users deposit
    receive() external virtual  payable {
        amounts[msg.sender] += msg.value;
        comparator(msg.sender);
        
    }

    // withdraw for administrator
    function withdraw(uint256 _amount)external   virtual payable OnlyAdmin{
        require(_amount<= address(this).balance, "Not enough balance");
        payable(admin).transfer(_amount);


    }

    

    // Comparator for top3 depositors
    function comparator(address user) internal  {
        uint256 balance = amounts[user];
        if (top3[0] == user || top3[1] == user || top3[2] == user){
            for (uint i=0; i<3; i++) 
            {
                for (uint j=i+1; j<3; j++) 
                {
                    if (top3[i]< top3[j]){
                        address temp = top3[i];
                        top3[i] = top3[j];
                        top3[j] = temp;
                    }
                }
            }
        }
        else {
            for (uint i = 0; i < 3; i++) {
                if (balance > amounts[top3[i]]) {
                    for (uint j = 2; j > i; j--) {
                        top3[j] = top3[j - 1];
                    }
                    top3[i] = user;
                    break;
                }
            }}
    }


    // show top3
    function show_top3() public view returns (address[3] memory) {
        return top3;
    }

    fallback() external payable {

    }
}



// Require deposit amount >0.001 ether (controlled by modifier)
// BigBank contract supports transferring administrators
// Also write an Ownable contract, transfer the administrator of BigBank to the Ownable contract, and ensure that only Ownable can call BigBank's withdraw().
// Write the withdraw() method, and only the administrator can withdraw funds through this method.
// Use an array to record the top 3 users with deposit amounts


// 题目的意思我没有很理解。按照我的理解，
//BigBank将管理员权限托管给Ownable，Ownable的管理员是实际的管理员，Ownable支持更换管理员，BigBank只接受Ownable的调用。


contract BigBank is Bank, IBank{   

    modifier GT0_001ETH(){
        require(msg.value>= 1e15, "Deposit needs greater than 0.001 ether");
        _;
    }

    //override for Only accept >0.001ether deposit
    receive() external override payable GT0_001ETH{ 
        amounts[msg.sender] += msg.value;
        comparator(msg.sender);
    }

    // 只有Ownable可以调用
    modifier OnlyOwnable(){
        // 这里先部署ownable
        require(msg.sender==address(0x3d33C01bCC36ac6A8f872599A9c9351c11Ef07E7),"Withdraw can only be manipulated By Ownable.");
        _;
    }

    function withdraw(uint256 _amount)external   override(Bank, IBank)  payable OnlyOwnable{
        require(_amount<= address(this).balance, "Not enough balance");
        payable (msg.sender).transfer(_amount);


    }

}



