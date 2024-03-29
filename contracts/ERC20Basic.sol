// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

contract ERC20Basic is IERC20 {

    string public constant name = "ERC20Basic"; // Set the ERC20 name
    string public constant symbol = "ERC"; // Set the ERC20 Symbol
    uint8 public constant decimals = 0; // Set the ERC20 Decimal point position
    address tokenFounder; // Set tokenFounder address variable


    mapping(address => uint256) balances; // address to token balance

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 100; // Set the total tokens supply

    // ERC20 constructor
   constructor() {
    balances[msg.sender] = totalSupply_; // Initialize the total tokens supply as the balance of the contract deployment address
    tokenFounder = msg.sender; // Sets the token founder as the  contract deployment address
    }

    // Returns the total tokens supply
    function totalSupply() public view returns (uint256) {
    return totalSupply_;
    }

    // Checks the balance of the accepted address
    function balanceOf(address tokenOwner) public  view returns (uint256) {
        return balances[tokenOwner];
    }

    // Transfer numTokens amount of ERC20 tokens to the reciver address
    function transfer(address receiver, uint256 numTokens) public  returns (bool) {
        require(numTokens <= balances[tokenFounder]); // Verify the amount of tokens to transfer exists in the total supply
        balances[tokenFounder] = balances[tokenFounder]-numTokens; // updates the total supply balance
        balances[receiver] = balances[receiver]+numTokens; // Updates the reciever tokens balance
        emit Transfer(tokenFounder, receiver, numTokens); // Trigers Transfer event
        return true; // Returns success
    }

    function approve(address delegate, uint256 numTokens) public  returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public  view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public  returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

