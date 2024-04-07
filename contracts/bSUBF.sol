//SPDX-License-Identifier:Unlicensed
pragma solidity ^0.8.20;

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool); 
}

contract bSUBF{
    IERC20 public token;
    constructor(address _tokenAddress){
        token = IERC20(_tokenAddress);
        token.approve(address(this),type(uint256).max);
    }

    receive() external payable {}

    function wrap() public payable{
        require(token.transferFrom(address(this),msg.sender, msg.value),"not enough tokens");
    }

   function unwrap(uint256 _amount) public {
    // Transfer tokens from the sender to the contract
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");

        // Get the contract's balance before the transfer
        uint256 contractBalanceBefore = address(this).balance;
        require(_amount<contractBalanceBefore,"not enough liquidity");

        // Transfer equivalent ether amount from contract to the sender
        require(payable(msg.sender).send(_amount), "Ether transfer failed");
    }


    function unlimitedAllowance()public{
        token.approve(address(this),type(uint256).max);
    }
}