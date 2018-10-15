pragma solidity ^0.4.11;

import "./TestToken.sol"; 
import "./SafeMath.sol";
import "./fetchPrice.sol";
/*
 */
contract TestTokenSale is fetchPrice{

  using SafeMath for uint256;

  address public admin;
  TestToken public tokenContract; 
  uint256 public tokenPrice; // this might needs to be changed to ETHUSD
  uint256 public tokensSold;
  
  event Sell(address _buyer, uint256 _amount);

  modifier onlyAdmin{
    require (msg.sender == admin);
    _;
  }

  // first one is the original 
  //constructor(EdenToken _tokenContract, uint256 _tokenPrice, uint256 _endTime) public{
  constructor(TestToken _tokenContract) public{

    admin = msg.sender;
    tokenContract = _tokenContract;
  }

  //high level purchase 
    function() external payable{
      //buyTokens(msg.sender); // uncomment this and change 
      buyTokensHere(msg.sender); 
    }

    //low level purchase with the function being called inside
  function buyTokensHere(address _beneficiary) public payable{ // change it to buyTokens
    
    require(msg.value != 0);
    uint256 weiAmount = msg.value;
    uint256 _numberOfTokens = _getTokenAmount(weiAmount);
    //need to transfer some tokens to the tokensale contract before performing this operation 
    tokenContract.transfer(_beneficiary, _numberOfTokens);
    tokensSold += _numberOfTokens;
    emit Sell(msg.sender, _numberOfTokens);
  }

  // gives the number of tokens to the amount of ether sent to contract
  // this is where we do the numbers wrt the ether sent to the sale address.
  function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256){    
    return _weiAmount.mul(price);
  }

  //token sale ends and the function related to that goes here
  function endSale() public onlyAdmin {
    admin.transfer(address(this).balance);
  }

  function emergencyExtract() public onlyAdmin{
    admin.transfer(address(this).balance);
  }

  function kill() onlyAdmin public{
    selfdestruct(admin);
  }

}

