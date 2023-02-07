//SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

interface IERC20 { 

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

contract NozToken is IERC20 { 

    uint256 _totalSupply = 20 ether;
    address _owner;

    string private _name;
    string private _symbol;

    constructor () { 
        _owner = msg.sender;
        _balances[_owner] = _totalSupply;
    }

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;


    function totalSupply() public override view returns (uint256) { 
        return _totalSupply;
    }

    function balanceOf(address account) public override view returns (uint256) { 
        return _balances[account];
    }

    function allowance(address owner, address spender) public override view returns (uint256) { 
        return _allowances[owner][spender];
    }


    function transfer(address recipient, uint256 amount) public override returns (bool) { 
        // :::: #TODO: add modifier for this checks
        require(_balances[msg.sender] >= amount, "Not enougth funds!");
        require(recipient != address(0), "Cannot send to 0x00... address");
        amount = amount * 1 ether;

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) { 
        // ::: #TODO add modifier for this
        require(_balances[msg.sender] >= amount, "Not enouth funds to fund allowance");
        require(spender != address(0), "Cannot send to 0x00... address");
        amount = amount * 1 ether;

        _allowances[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
        
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool){ 
        require(_balances[sender] >= amount, "Not enougth funds!");
        require((sender != address(0)) && (recipient != address(0)), "Cannot perform operation if one of the adresses are 0");
        amount = amount * 1 ether;

        _balances[sender] -= amount;
        _allowances[sender][recipient] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

}