// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./PriceConverter.sol";

error NotOwner();

contract FundMe{
    
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address [] public funders;
    mapping(address=>uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender;
    }

    // Wallets and Contracts can hold native tokens
    function fund() public payable{
       require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough funds"); // 1e18 == 1 * 10 ^18
       funders.push(msg.sender);
       addressToAmountFunded[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner{

        // Using for-loop in solidity
        for (uint256 funderIndex=0;funderIndex < funders.length;funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0; // resetting the amountFunded to 0 as soon as withdraw() is called. It will not be available in future calls
        }
        // Resetting the arrray
        funders = new address[](0);

        // Actually withdraw funds

        // Methods to send native tokens
        // 1. Transfer
        payable(msg.sender).transfer(address(this).balance);

        // 2. Send
        bool sendSuccess = payable (msg.sender).send(address(this).balance);
        require(sendSuccess,"Send failed!");

        // 3. Call
        (bool callSuccess,) = payable (msg.sender).call{value: address(this).balance}("");
        require(callSuccess,"Call Failed");

    }

    modifier onlyOwner{
        if(msg.sender != i_owner){ revert NotOwner();}        
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function

    // Receive and Fallback function in Solidity

  // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    receive() external payable{
        fund();
    }

    fallback() external payable {
        fund();
     }
   

    
}
