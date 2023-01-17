pragma solidity 0.8.17;

contract SmartWallet { 

    struct wallet { 
        address owner;
        uint balance;
        address[] guardians;
        mapping(address => uint) allowances;
        uint8 nAllowances;
    }

    fallback() external payable { 
        wallets[msg.sender].balance += msg.value;
    }

    mapping(address => wallet) public wallets;

    function createWallet() external payable { 
        wallet storage newWallet = wallets[msg.sender];
        newWallet.owner = msg.sender;
        newWallet.balance += msg.value;
    }

    function sendMoney(address payable to) external payable { 
        // safety Check
        uint transferValue = msg.value;
        wallet storage senderWallet = wallets[msg.sender];
        require(transferValue <= senderWallet.balance, "Not enougth funds");
        require(senderWallet.guardians.length <= 5 && senderWallet.guardians.length >=3, "Cannot perform operation. Insufficient number of guardians");
        senderWallet.balance -= transferValue;
        // Actual Operation
        to.transfer(transferValue);
    }

    function setAllowance(address to, uint amount) external { 
        wallet storage senderWallet = wallets[msg.sender];
        senderWallet.allowances[to] = amount;
    }

    function addGuardian(address guardian) external {
        wallet storage senderWallet = wallets[msg.sender];
        assert(msg.sender == senderWallet.owner);
        senderWallet.guardians.push(guardian);
        require(senderWallet.guardians.length <= 5, "Maximum number of guardians reached (5)");
    }
}
