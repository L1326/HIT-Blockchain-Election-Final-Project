// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Imports an the ERC721 contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Imports an the Counters contract from OpenZeppelin
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721Basic is ERC721 {
    using Counters for Counters.Counter; // Assign all the functions inside the Counters library to the Counter struct.

    Counters.Counter private _tokenId; // Create a Counter instance as a _tokenID
    
    // ERC721 constructor
    constructor() ERC721('ERC721Basic', 'ERC721') {}

    // Creates new token based on the _tokenID, and assign it to the owner address
    function mint(address owner) public {
        _tokenId.increment(); // Increment the _tokenID counter by 1

        uint256 newTokenID = _tokenId.current(); // Generate te new token
        _mint(owner, newTokenID); // mint the ERC721 token to the owner address
    }
}
