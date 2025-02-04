// SPDX-License-Identifier: MIT

// Version greater than 
// pragma solidity ^0.8.15;

// Vesrion within a range
// pragma solidity >= 0.8.7 < 0.9.0;

//Declare version of solidity
pragma solidity ^0.8.26;

contract SimpleStorage {   
    // Solidity Data Types ( boolean, uint, int, address, bytes)
    uint256 public favouriteNumber;   

    // Mapping
    mapping(string => uint256) public moveTofavouriteNumbers;

    //Creating objects
    struct People{
        uint256 favouriteNumber;
        string name;
    }

    // Working with Arrays
    //uint256[] public favouriteNumberList;
    People[] public  people;

    function addPerson(string memory _name, uint256 _favouriteNumber) public{
        People memory newPerson =People({favouriteNumber: _favouriteNumber,name :_name});
        people.push(newPerson);
    }

    function store(uint256 _favouriteNumber) public{
        favouriteNumber = _favouriteNumber;
    }

    // Functions that don't spend gas are denoted with the keyword view and pure
    function retrieve() public view returns (uint256){  
            return favouriteNumber;
        }
    





}
