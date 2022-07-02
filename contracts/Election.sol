// SPDX-License-Identifier: MIT
pragma solidity ^0.5.16;

contract Election{
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
     constructor() public {
        // electionEnd = now + (1 * 1 minutes);
    }

    function addCandidate (string memory _name) public {
        require(elecetionEndTimeCheck);
        candidatesQuantity ++;
        candidates[candidatesQuantity] = Candidate(candidatesQuantity, _name, 0); // Adds a candidate to the cadidates list with candidatesQuantity as the id, name, initial voteCount
        emit addCandidateEvent();
    }

    function setElectionEndTimer (uint electionEndTimer) public {
        electionEnd = now + (electionEndTimer * 1 minutes);
        elecetionEndTimeCheck = true;
    }

    function checkElectionResults() public{
        if (now > electionEnd){
            displayElectionResults = true;
            emit displayResults(); // Trigger display results event
        }else{
            emit timerNotEnd(); // Trigger still time for election event
        }
        }

    function vote (uint _candidateId) public {
        require(now < electionEnd);
        require(!voters[msg.sender]); // Check account haven't voted already
        require(_candidateId > 0 && _candidateId <= candidatesQuantity); // Check for valid candidate
        voters[msg.sender] = true; // Record account that has voted in the voters list
        candidates[_candidateId].voteCount++; // Update cadidate votes quantity
        emit votedEvent(_candidateId); // Trigger voted event
    }

}