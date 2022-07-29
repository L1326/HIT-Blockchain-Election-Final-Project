// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC20Basic.sol';
import './ERC721Basic.sol';

contract Election{

    ERC20Basic token;
    ERC721Basic ERC721Token;

    // Candidate model
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(address => bool) public voters; // Store voted accounts

    mapping(uint => Candidate) public candidates; // Fetch a Candidate

    uint public candidatesQuantity; // Store Candidates Quantity
    uint public electionEnd;
    uint i;
    bool public elecetionEndTimeCheck;
    bool public displayElectionResults = false;

    event votedEvent (
        uint indexed _candidateId
    );

    event addCandidateEvent (
    );

    event displayResults ();

    event timerNotEnd ();

    // Constructor
     constructor(ERC20Basic ERC20BasicAddress, ERC721Basic ERC721TokenAddress) {
        // electionEnd = now + (1 * 1 minutes);
        token = ERC20BasicAddress;
        ERC721Token = ERC721TokenAddress;
    }

    function addCandidate (string memory _name) public {
        require(elecetionEndTimeCheck);
        candidatesQuantity ++;
        candidates[candidatesQuantity] = Candidate(candidatesQuantity, _name, 0); // Adds a candidate to the cadidates list with candidatesQuantity as the id, name, initial voteCount
        emit addCandidateEvent();
    }

    function setElectionEndTimer (uint electionEndTimer) public {
        electionEnd = block.timestamp + (electionEndTimer * 1 minutes);
        elecetionEndTimeCheck = true;
    }

    function checkElectionResults() public{
        if (block.timestamp > electionEnd){
            displayElectionResults = true;
            emit displayResults(); // Trigger display results event
        }else{
            emit timerNotEnd(); // Trigger still time for election event
        }
        }

    function vote (uint _candidateId) public {
        require(block.timestamp < electionEnd);
        require(ERC721Token.balanceOf(msg.sender)>0);
        require(!voters[msg.sender]); // Check account haven't voted already
        require(_candidateId > 0 && _candidateId <= candidatesQuantity); // Check for valid candidate
        voters[msg.sender] = true; // Record account that has voted in the voters list
        candidates[_candidateId].voteCount++; // Update cadidate votes quantity
        token.transfer(msg.sender, 1);
        emit votedEvent(_candidateId); // Trigger voted event
    }

    function voteRegistration() public {
        require(ERC721Token.balanceOf(msg.sender) == 0);
        ERC721Token.mint(msg.sender);
    }

}