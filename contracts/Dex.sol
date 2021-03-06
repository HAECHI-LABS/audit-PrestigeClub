// SPDX-License-Identifier: ISC



pragma solidity >=0.6.0 <0.8.0;

// import "./Context.sol";
// import "./IERC20.sol";
import "./libraries/SafeMath.sol";
import "./Peth.sol";

contract PEthDex is PEth("P-Ethereum", "PETH", address(this)) {
    using SafeMath for uint256;

    event Bought(address indexed adr, uint256 amount);
    event Sold(address indexed adr, uint256 amount);

    address owner;

    constructor() public {
        _mint(_msgSender(), 1 ether);
        owner = _msgSender();
        // _mint(address(this), 100000);

    }

    function deposit() payable public { }

    function buy() payable public {

        uint256 amountTobuy = msg.value;

        // uint256 dexBalance = balanceOf(address(this));

        require(amountTobuy > 0, "You need to send some ether");
        // require(amountTobuy <= dexBalance, "Not enough tokens in the reserve");

        // _transfer(address(this), msg.sender, amountTobuy);
        payable(owner).transfer(amountTobuy);

        _mint(msg.sender, amountTobuy);

        emit Bought(msg.sender, amountTobuy);

    }

    function sell(uint256 amount) public {
        
        require(amount > 0, "You need to sell at least some tokens");
        require(address(this).balance >= amount, "Not enough Ether to sell amount");

        // uint256 allowance = allowance(msg.sender, address(this));
        // require(allowance >= amount, "Check the token allowance");

        uint256 balance = balanceOf(msg.sender);
        require(balance >= amount, "Not enough funds to sell");

        // _transfer(msg.sender, address(this), amount);
        _burn(msg.sender, amount);

        bool success = payable(msg.sender).send(amount);
        require(success, "Transfer of ether not successful");
        emit Sold(msg.sender, amount);

    }

}