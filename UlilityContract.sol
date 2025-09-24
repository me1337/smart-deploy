// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.29;

import "./IUlilityContract.sol";

contract BigBoss is IUlilityContract{



    error Alreadyinitialized();

    modifier notInitialized(){
        require(!initialized, Alreadyinitialized());
        _;
    }

    uint256 public number;
    address public bigBoss;
    bool private initialized;

     function initialize(bytes memory _initData) external notInitialized returns (bool) {
        (uint256 _number, address _bigBoss) =abi.decode(_initData, (uint256, address));
        number = _number;
        bigBoss = _bigBoss;
        initialized = true;
        return true;
    }

    function getInitData(uint256 _number, address _bigBoss ) external pure returns (bytes memory){
        return abi.encode(_number, _bigBoss);
    }





    function doSmth() external view returns(uint256 , address ){
        return (number, bigBoss);
    }
}