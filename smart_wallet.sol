//SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract Consumer { 

    function getBalance() external view returns(uint) { 
        return address(this).balance;
    }

    function deposit() external payable {}
}

contract SmartContract { 

    address public owner;
    
    mapping (address => uint) allowances;
    mapping (address => bool) guardians;
    mapping (address => mapping(address => bool)) newOwnerVoters;
    address nextOwner;
    uint8 constant newOwnerVoteResetCount = 3;
    uint8 newOwenerVotes;

    constructor() { 
        owner = msg.sender;
    }

    function voteNewOwner(address _newProposedOwner) external { 
        require(guardians[msg.sender], "You are not a guardian or you voting was disabled");
        require(!newOwnerVoters[_newProposedOwner][msg.sender], "You've already voted for this new proposed owener. Aborting...");
        
        if(nextOwner != _newProposedOwner) { 
            nextOwner = _newProposedOwner;
            newOwenerVotes = 0;
        }

        newOwenerVotes++;
        newOwnerVoters[_newProposedOwner][msg.sender] = true;
        if(newOwenerVotes >= newOwnerVoteResetCount) { 
            owner = nextOwner;
            nextOwner = address(0);
        }
    }

    function setGuardian(address _guardian, bool _isEnabled) external { 
        require(msg.sender == owner, "You are not the owner. Aborting...");
        guardians[_guardian] = _isEnabled;
    }

    function setAllowance(address _for, uint _amount) external { 
        require(msg.sender == owner, "You are not the owner. Aborting...");
        allowances[_for] = _amount;
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) external payable returns(bytes memory){ 
        if(msg.sender != owner) { 
            // :: Only transfer the allowed balance for the user
            require(_amount > 0, "Invalid amount to transfer, aborting...");
            require(allowances[msg.sender] >= _amount, "Amount greater then allowance of user, aborting...");

            allowances[msg.sender] -= _amount;
        }

        (bool isSuccess, bytes memory responseData) = _to.call{value: _amount}(_payload);
        return responseData;
    }

}

