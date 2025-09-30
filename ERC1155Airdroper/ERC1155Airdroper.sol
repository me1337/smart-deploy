// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.29;

import "../IUlilityContract.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract ERC1155Airdroper is IUlilityContract, Ownable{

    constructor() Ownable(msg.sender) {

    }



    IERC1155 public token;
    address public treasury;

    error Alreadyinitialized();
    error ArraysLenghtMismatch();
    error NeedToApprovedTokens();
    error TransferFailed();

    modifier notInitialized(){
        require(!initialized, Alreadyinitialized());
        _;
    }

    
    bool private initialized;
    
    function airdrop(address[] calldata receivers, uint256[] calldata amounts,uint256[] calldata tokenId) external onlyOwner {
        require(receivers.length == amounts.length && receivers.length == tokenId.length , ArraysLenghtMismatch());
       require(token.isApprovedForAll(treasury,address(this)),NeedToApprovedTokens() );

       for(uint256 i =0 ; i<amounts.length; i ++){
        token.safeTransferFrom(treasury,receivers[i],tokenId[i],amounts[i],"");
       }
       
    }


     function initialize(bytes memory _initData) external notInitialized returns (bool) {
        (address _token,  address _treasury,  address _owner) =abi.decode(_initData, (address,address, address));
        token = IERC1155(_token);
       
        treasury = _treasury;

        Ownable.transferOwnership(_owner);

        initialized = true;
        return true;
    }

    function getInitData(address _token,  address _treasury,  address _owner ) external pure returns (bytes memory){
        return abi.encode(_token,  _treasury, _owner);
    }





    
}