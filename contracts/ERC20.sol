// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
}

contract ERC20 is IERC20 {
    address private owner;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _owner, string memory _name, string memory _symbol, uint8 _decimals) {
        owner = _owner;
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can mint tokens");
        _;
    }

    function mint(uint _initialSupply) external onlyOwner {
        totalSupply = _initialSupply * 10**uint256(decimals);
        balanceOf[owner] += totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address recipient, uint amount) external override returns (bool) {
        require(recipient != address(0), "ERC20: transfer to the zero address");
        balanceOf[owner] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function burn(uint amount) external {
        require(balanceOf[owner] >= amount, "ERC20: burn amount exceeds balance");
        balanceOf[owner] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}