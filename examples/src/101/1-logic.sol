// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "@openzeppelin/contracts/access/Ownable.sol";


uint constant N_VAULT = 10;


/**
	@dev This contract includes an examples of a logic bug. Line 33 updates the accumulator only when entering the if statement, instead of updating it at the end of the loop.
	@custom:exercise This contract is part of JC's basic examples at https://github.com/jcr-security/solidity-security-teaching-resources
*/
contract Example1 is Ownable {

	struct Vault {
		bool locked;
		uint[] wallet;
	}

	Vault[N_VAULT] vaults;

    function checkCredit() external onlyOwner {
		uint accumulator = 0;
		for (uint i = 0; i < N_VAULT; i++) { 	
			for (uint j = 0; i< vaults[i].wallet.length; j++) {
				accumulator += vaults[i].wallet[j];
			}
			
			if (accumulator < 1000) {
				vaults[i].locked = true;
				accumulator = 0; // <--- This line should be outside the if statement
			}		
		}
    }


	function deposit(uint n_vault) external payable {
		require(n_vault < N_VAULT, "Vault does not exist");

		vaults[0].wallet.push(msg.value);
	}


	function vaultState(uint n_vault) public view returns (bool) {
		return vaults[n_vault].locked;
	}

}
