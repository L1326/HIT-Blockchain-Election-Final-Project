App = {
  web3Provider: null,
  contracts: {},
  account: '0x0',
  hasVoted: false,

  init: function() {
    return App.initWeb3();
  },

  initWeb3: function() {
    // TODO: refactor conditional
    if (typeof web3 !== 'undefined') {
      // If a web3 instance is already provided by Meta Mask.
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      // Specify default instance if no web3 instance provided
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      web3 = new Web3(App.web3Provider);
    }
    web3.eth.defaultAccount = '0xBF45f7Ce4f085ED923b67d4ff1DaaBE07bBc60CE';
    return App.initContract();
  },

  initContract: function() {
    $.getJSON("Election.json", function(election) {
      // Instantiate a new truffle contract from the artifact
      App.contracts.Election = TruffleContract(election);
      // Connect provider to interact with contract
      App.contracts.Election.setProvider(App.web3Provider);

      App.listenForEvents();

      //App.listenForAddCandidateEvent();

      App.listenForDisplayResultsEvents();

      App.listenForTimerNotEndEvents();

      return App.render();
    });
  },

  // Listen for events emitted from the contract
  listenForEvents: function() {
    App.contracts.Election.deployed().then(function(instance) {
      // Restart Chrome if you are unable to receive this event
      // This is a known issue with Metamask
      // https://github.com/MetaMask/metamask-extension/issues/2393
      instance.votedEvent({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        console.log("event triggered", event)
        // Reload when a new vote is recorded
        App.render();
      });
    });
  },

  listenForAddCandidateEvent: function(){
    App.contracts.Election.deployed().then(function(instance) {
      // Restart Chrome if you are unable to receive this event
      // This is a known issue with Metamask
      // https://github.com/MetaMask/metamask-extension/issues/2393
      instance.addCandidateEvent({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        console.log("event triggered", event)
        // Reload when a new vote is recorded
        App.render();
      });
    });
  },

  listenForDisplayResultsEvents: function() {
    App.contracts.Election.deployed().then(function(instance) {
      // Restart Chrome if you are unable to receive this event
      // This is a known issue with Metamask
      // https://github.com/MetaMask/metamask-extension/issues/2393
      instance.displayResults({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        console.log("event display results triggered", event)
        // Reload when a new vote is recorded
        App.render();
      });
    });
  },

  listenForTimerNotEndEvents: function() {
    App.contracts.Election.deployed().then(function(instance) {
      // Restart Chrome if you are unable to receive this event
      // This is a known issue with Metamask
      // https://github.com/MetaMask/metamask-extension/issues/2393
      instance.timerNotEnd({}, {
        fromBlock: 0,
        toBlock: 'latest'
      }).watch(function(error, event) {
        console.log("event timer not end triggered", event);
        alert("Election didn't end yet! please check again later :)");
        App.render();
      });
    });
  },

  render: function() {
    var electionInstance;
    var loader = $("#loader");
    var content = $("#content");
    var electionDisplay = $("#electionDisplay");

    loader.show();
    content.hide();
    electionDisplay.hide();

  // Load account data
    web3.eth.getCoinbase(function(err, account) {
      if (err === null) {
        App.account = account;
        $("#accountAddress").html("Your Account: " + account);
      }
    });

    // Load contract data
    App.contracts.Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.candidatesQuantity();
    }).then(function(candidatesQuantity) {
      var candidatesResults = $("#candidatesResults");
      candidatesResults.empty();

      var candidatesSelect = $('#candidatesSelect');
      candidatesSelect.empty();

      for (var i = 1; i <= candidatesQuantity; i++) {
        electionInstance.candidates(i).then(function(candidate) {
          var id = candidate[0];
          var name = candidate[1];

          // Render candidate Result
          var candidateTemplate = "<tr><th>" + id + "</th><td>" + name + "</td></tr>"
          candidatesResults.append(candidateTemplate);

          // Render candidate ballot option
          var candidateOption = "<option value='" + id + "' >" + name + "</ option>"
          candidatesSelect.append(candidateOption);
        });
      }
      return electionInstance.voters(App.account);
    }).then(function(hasVoted) {
      // Do not allow a user to vote
      if(hasVoted) {
        $('form').hide();
      }
      App.contracts.Election.deployed().then(function(instance) {
        electionInstance = instance;
        return electionInstance.displayElectionResults();
      }).then(function(displayElectionResults) {
        if(displayElectionResults){
          console.log("display Results", displayElectionResults)
          electionDisplay.show();
          content.hide();
        }
        else {
          loader.hide();
          content.show();
        }
      });
    }).catch(function(error) {
      console.warn(error);
    });

    //load election results
    App.contracts.Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.candidatesQuantity();
    }).then(function(candidatesQuantity) {
      var electionResults = $("#electionResults");
      electionResults.empty();

      var electionSelect = $('#electionSelect');
      electionSelect.empty();

      for (var i = 1; i <= candidatesQuantity; i++) {
        electionInstance.candidates(i).then(function(candidate) {
          var id = candidate[0];
          var name = candidate[1];
          var voteCount = candidate[2];

          // Render candidate Result
          var electionTemplate = "<tr><th>" + id + "</th><td>" + name + "</td><td>" + voteCount + "</td></tr>"
          electionResults.append(electionTemplate);

        });
      }
      return electionInstance.voters(App.account);
    }).then(function(hasVoted) {
      // Do not allow a user to vote
      if(hasVoted) {
        $('form').hide();
      }
      loader.hide();
    }).catch(function(error) {
      console.warn(error);
    });

    //check timer
    App.contracts.Election.deployed().then(function(instance) {
      electionInstance = instance;
      return electionInstance.displayElectionResults();
    }).then(function(displayElectionResults) {
      if(displayElectionResults){
        console.log("display Results", displayElectionResults)
        electionDisplay.show();
        content.hide();
      }
    });
  },

  castVote: function() {
    var candidateId = $('#candidatesSelect').val();
    App.contracts.Election.deployed().then(function(instance) {
      return instance.vote(candidateId, { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },

  addCandidate: function() {
    var candidateName = $('#candidateNameID').val();
    console.log("candidate name test", candidateName)
    App.contracts.Election.deployed().then(function(instance) {
      return instance.addCandidate(candidateName,  { from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },

  electionEndTimer: function() {
    var electionEndTimer = parseInt($('#electionEndTimerID').val());
    console.log("Election end test", electionEndTimer)
    App.contracts.Election.deployed().then(function(instance) {
      return instance.setElectionEndTimer(electionEndTimer,  { from: App.account });
    })
  },

  checkResults: function() {
    console.log("check elections results")
    App.contracts.Election.deployed().then(function(instance) {
      return instance.checkElectionResults({ from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },

  voteRegistration: function() {
    console.log("voter registered for voting")
    App.contracts.Election.deployed().then(function(instance) {
      return instance.voteRegistration({ from: App.account });
    }).then(function(result) {
      // Wait for votes to update
      $("#content").hide();
      $("#loader").show();
    }).catch(function(err) {
      console.error(err);
    });
  },
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});