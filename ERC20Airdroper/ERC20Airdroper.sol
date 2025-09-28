// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.29;

import "../IUlilityContract.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract ERC20Airdroper is IUlilityContract, Ownable{

    constructor() Ownable(msg.sender) {

    }



    IERC20 public token;
    uint256 public amount;
    address public treasury;

    error Alreadyinitialized();
    error ArraysLenghtMismatch();
    error NotEnoughApprovedTokens();
    error TransferFailed();

    modifier notInitialized(){
        require(!initialized, Alreadyinitialized());
        _;
    }

    
    bool private initialized;
    
    function airdrop(address[] calldata receivers, uint256[] calldata amounts) external onlyOwner {
        require(receivers.length == amounts.length , ArraysLenghtMismatch());
        require(token.allowance(treasury,address(this)) >= amount, NotEnoughApprovedTokens());
        for(uint256 i = 0 ; i<receivers.length; i++){
            require(token.transferFrom(treasury,receivers[i],amounts[i]),TransferFailed());
        }
    }


     function initialize(bytes memory _initData) external notInitialized returns (bool) {
        (address _token, uint256 _amount, address _treasury,  address _owner) =abi.decode(_initData, (address,uint256,address, address));
        token = IERC20(_token);
        amount = _amount;
        treasury = _treasury;

        Ownable.transferOwnership(_owner);

        initialized = true;
        return true;
    }

    function getInitData(address _token, uint256 _amount, address _treasury,  address _owner ) external pure returns (bytes memory){
        return abi.encode(_token, _amount, _treasury, _owner);
    }





    
}