// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC20Basic.sol';
import './ERC721Basic.sol';

contract Election{

    ERC20Basic token; // ERC20 token instance
    ERC721Basic ERC721Token; // ERC721 token instance

    // Candidate struct model
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(address => bool) public voters; // Store voted accounts

    mapping(uint => Candidate) public candidates; // Fetch a Candidate

    uint public candidatesQuantity; // Store Candidates Quantity
    uint public electionEnd; // Store election end time
    bool public elecetionEndTimeCheck; // Set if election end
    bool public displayElectionResults = false; // Set to enable results view

    // Triggered when user has voted
    event votedEvent (
        uint indexed _candidateId
    );

    // Triggered when candidate is added to the election
    event addCandidateEvent (
    );

    // Triggered when election results are displayed
    event displayResults ();

    // Triggered when election time ended
    event timerNotEnd ();

    // Constructor
     constructor(ERC20Basic ERC20BasicAddress, ERC721Basic ERC721TokenAddress) {
        token = ERC20BasicAddress; // Assign ERC20Basic contract address to the token instance
        ERC721Token = ERC721TokenAddress; // Assign ERC721Basic contract address to the ERC721Token instance
    }

    // Add cadidate for the election
    function addCandidate (string memory _name) public {
        require(elecetionEndTimeCheck); // require election still active
        candidatesQuantity ++; // increase cadidates quantity
        // Adds a candidate to the cadidates list with candidatesQuantity as the id, name, initial voteCount
        candidates[candidatesQuantity] = Candidate(candidatesQuantity, _name, 0); 
        emit addCandidateEvent(); // emit addCandidate event
    }

    // Set the duration of time the election will take place
    function setElectionEndTimer (uint electionEndTimer) public {
        electionEnd = block.timestamp + (electionEndTimer * 1 minutes); // calculate the end time, based on the current block timestamp
        elecetionEndTimeCheck = true; // set the end time chec to true
    }

    // Check if the election has ended and the results can be displayed
    function checkElectionResults() public{
        // Check if the election end time has over
        if (block.timestamp > electionEnd){
            displayElectionResults = true;
            emit displayResults(); // Trigger display results event
        }else{
            emit timerNotEnd(); // Trigger still time for election event
        }
        }

    // Accepts a vote from the user, checks if election time did'nt end, check if the user is eligible for voting and hasn't voted yet, update the vote, transfer ERC20 token
    function vote (uint _candidateId) public {
        require(block.timestamp < electionEnd); // Checks if election is still occurs
        require(ERC721Token.balanceOf(msg.sender)>0); // Checks if user has an ERC721 token (eligible for voting)
        require(!voters[msg.sender]); // Check account haven't voted already
        require(_candidateId > 0 && _candidateId <= candidatesQuantity); // Check for valid candidate
        voters[msg.sender] = true; // Record account that has voted in the voters list
        candidates[_candidateId].voteCount++; // Update cadidate votes quantity
        token.transfer(msg.sender, 1); // Transfer an ERC20 token to the user as a voting reward
        emit votedEvent(_candidateId); // Trigger voted event
    }

    // Assign a unique ERC721 token to the registered user so he can vote
    function voteRegistration() public {
        require(ERC721Token.balanceOf(msg.sender) == 0);
        ERC721Token.mint(msg.sender);
    }

}