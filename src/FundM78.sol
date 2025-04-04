// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

error FundM78__NotOwner();

/**
 * @title 资助m78
 * @author qichao
 * @notice 这个合约用来帮助m78星球进行重建
 */
contract FundM78{

    address private immutable i_owner;
    //贡献用户地址
    address[] private s_funders;
    //用户资助金额
    mapping(address => uint256) private s_addressToAmountFunded;

    event Funded(address indexed donor, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundM78__NotOwner();
        _;
    }

    constructor() {
        i_owner = msg.sender;
    }

    //资助
    function fund() public payable {
        require(msg.value > 0, "You need to spend more ETH!");
        if (s_addressToAmountFunded[msg.sender] == 0) {
            s_funders.push(msg.sender);
        }
        s_addressToAmountFunded[msg.sender] += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = i_owner.call{value: balance}("");
        require(success, "Transfer failed");
        emit Withdrawn(i_owner, balance);
    }

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getFunderCount() public view returns(uint){
        return s_funders.length;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

}
