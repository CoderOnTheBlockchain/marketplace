const Voting = artifacts.require("Voting");
const { BN, expectRevert, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');

contract('Voting', accounts => {
    
    const OwnerAccount = accounts[0];
    
    const Account1 = accounts[1];
    const Account2 = accounts[2];
    const Account3 = accounts[3];
    const Account4 = accounts[4];
    const Account5 = accounts[5];
    const Account6 = accounts[6];
    const Account7 = accounts[7];
    const Account8 = accounts[8];
    const Account9 = accounts[9];
 
    const ListAccounts = [Account1,Account2,Account3,Account4,Account5,Account6,Account7,Account8,Account9];

    const RegisteringVoters = new BN(0);
    const ProposalsRegistrationStarted = new BN(1);
    const ProposalsRegistrationEnded = new BN(2);
    const VotingSessionStarted = new BN(3);
    const VotingSessionEnded = new BN(4);
    const VotesTallied = new BN(5);

    const ErrorOwner = "Ownable: caller is not the owner";

    let VotingInstance;

    describe("Test step for Registering Voters", function () {

        beforeEach(async function () {
            VotingInstance = await Voting.new({from:OwnerAccount});
        });

        it("test add voter and get voter", async () => {

            await VotingInstance.addVoter(Account1, {from: OwnerAccount});
            const newVoter = await VotingInstance.getVoter(Account1, {from: Account1});
          
            //verify the new voter is create and is registred
            expect(newVoter.isRegistered).to.be.true;

        });

        it("test requires for addVoter", async () => {
            await expectRevert(VotingInstance.addVoter(Account2, {from: Account1}), ErrorOwner);
           
            await VotingInstance.addVoter(Account1, {from: OwnerAccount});
            await expectRevert(VotingInstance.addVoter(Account1, {from: OwnerAccount}), "Already registered");
            
            await VotingInstance.startProposalsRegistering({from: OwnerAccount});
            await expectRevert(VotingInstance.addVoter(Account1, {from: OwnerAccount}), "Voters registration is not open yet");
        });

         it("test event for addVoter", async () => {
             const findEvent = await VotingInstance.addVoter(Account1, {from: OwnerAccount});
             expectEvent(findEvent, "VoterRegistered", {voterAddress: Account1});
         });

    });

    describe("Test step for Proposals Registration Started Part 1", function () {

        beforeEach(async function () {
            VotingInstance = await Voting.new({from:OwnerAccount});
        });

        it("test require startProposalsRegistering", async () => {
            await expectRevert(VotingInstance.startProposalsRegistering({from: Account1}), ErrorOwner);
            await VotingInstance.startProposalsRegistering({from: OwnerAccount});
            await expectRevert(VotingInstance.startProposalsRegistering({from: OwnerAccount}), "Registering proposals cant be started now");
        });

        it("test event startProposalsRegistering", async () => {
            const findEvent = await VotingInstance.startProposalsRegistering({from: OwnerAccount});
            expectEvent(findEvent, "WorkflowStatusChange", {previousStatus: RegisteringVoters, newStatus: ProposalsRegistrationStarted});
        });

    });

    describe("Test step for Proposals Registration Started Part 2", function () {

        beforeEach(async function () {
            VotingInstance = await Voting.new({from: OwnerAccount});

            for (var nbAccounts=0; nbAccounts < ListAccounts.length; nbAccounts++) {
                await VotingInstance.addVoter(ListAccounts[nbAccounts], {from: OwnerAccount});
            }

            await VotingInstance.startProposalsRegistering({from: OwnerAccount});
        });

        it("test function getOneProposal", async () => {
            for (var nbAccounts=0; nbAccounts < ListAccounts.length; nbAccounts++) {
                await VotingInstance.addProposal("Proposal_"+nbAccounts, {from: ListAccounts[nbAccounts]});
           }

            const proposal_1 = await VotingInstance.getOneProposal(new BN(0), {from: Account1});
            const proposal_2 = await VotingInstance.getOneProposal(new BN(1), {from: Account2});
 
            await expectRevert(VotingInstance.addProposal("", {from: Account1}), "Vous ne pouvez pas ne rien proposer");
            await expectRevert(VotingInstance.addProposal("Proposal_12", {from: OwnerAccount}), "You're not a voter");

            expect(proposal_1.voteCount).to.be.bignumber.equal(new BN(0), "vote count = 0");

            const findEvent = await VotingInstance.addProposal("Proposal_9", {from: Account1});
            expectEvent(findEvent, "ProposalRegistered", {proposalId: new BN(9)});
 
        });

       
          it("test step end Proposals Registering", async () => {
              await expectRevert(VotingInstance.endProposalsRegistering({from: Account1}), ErrorOwner );

               const findEvent = await VotingInstance.endProposalsRegistering({from: OwnerAccount});
               expectEvent(findEvent, "WorkflowStatusChange", {previousStatus: ProposalsRegistrationStarted, newStatus:  ProposalsRegistrationEnded}); 

               await VotingInstance.startVotingSession({from: OwnerAccount});
               await expectRevert(VotingInstance.endProposalsRegistering({from: OwnerAccount}), "Registering proposals havent started yet");
          });

        it("test step start Voting Session", async () => {
            await expectRevert(VotingInstance.startVotingSession({from: Account1}), ErrorOwner);
            await expectRevert(VotingInstance.startVotingSession({from: OwnerAccount}), "Registering proposals phase is not finished");

            await VotingInstance.endProposalsRegistering({from: OwnerAccount});
            const findEvent = await VotingInstance.startVotingSession({from: OwnerAccount});
            
            expectEvent(findEvent, "WorkflowStatusChange", {previousStatus: ProposalsRegistrationEnded, newStatus: VotingSessionStarted});
        });
    });

    context("Test step for Voting Session Started", function() {

        beforeEach(async function () {
    
            VotingInstance = await Voting.new({from: OwnerAccount});

            for (var nbAccounts=0; nbAccounts < ListAccounts.length; nbAccounts++) {
                await VotingInstance.addVoter(ListAccounts[nbAccounts], {from: OwnerAccount});
            }

            await VotingInstance.startProposalsRegistering({from: OwnerAccount});

            for (var nbAccounts=0; nbAccounts < 5; nbAccounts++) {
                await VotingInstance.addProposal("Proposal_"+nbAccounts, {from: ListAccounts[nbAccounts]});
           }

            await VotingInstance.endProposalsRegistering({from: OwnerAccount});
          
            await expectRevert(VotingInstance.setVote(new BN(1), {from: Account4}), "Voting session havent started yet");
         
            await VotingInstance.startVotingSession({from: OwnerAccount});
        });

        it("test setVote", async () => {
            await expectRevert(VotingInstance.setVote(new BN(0), {from: OwnerAccount}), "You're not a voter");

            await VotingInstance.setVote(new BN(1), {from: Account1});
            await expectRevert(VotingInstance.setVote(new BN(1), {from: Account1}), "You have already voted");

            await expectRevert(VotingInstance.setVote(new BN(20), {from: Account3}), "Proposal not found");

 
            const findEvent =  await VotingInstance.setVote(new BN(1), {from: Account6});
            const testVoter = await VotingInstance.getVoter(Account6,{from: Account1});

             expect(testVoter.votedProposalId).to.be.bignumber.equal(new BN(1), "Account6 has Proposal_1");

             expect(testVoter.hasVoted).to.equal(true, "Account6 has voted");
              
             expectEvent(findEvent, "Voted", {voter: Account6, proposalId: new BN(1)});

        });

        it("test end Voting Session", async () => {
            await expectRevert(VotingInstance.endVotingSession({from: Account1}), ErrorOwner);

            const findEvent = await VotingInstance.endVotingSession({from: OwnerAccount});

            await expectRevert(VotingInstance.endVotingSession({from: OwnerAccount}), "Voting session havent started yet");
            expectEvent(findEvent, "WorkflowStatusChange", {previousStatus: VotingSessionStarted, newStatus: VotingSessionEnded}); 
        });
    });

    context("Test step for Voting Session Ended", function() {
          beforeEach(async function () {

            VotingInstance = await Voting.new({from: OwnerAccount});

            for (var nbAccounts=0; nbAccounts < ListAccounts.length; nbAccounts++) {
                await VotingInstance.addVoter(ListAccounts[nbAccounts], {from: OwnerAccount});
            }

            await VotingInstance.startProposalsRegistering({from: OwnerAccount});

            for (var nbAccounts=0; nbAccounts < ListAccounts.length; nbAccounts++) {
                await VotingInstance.addProposal("Proposal_"+nbAccounts, {from: ListAccounts[nbAccounts]});
           }

            await VotingInstance.endProposalsRegistering({from: OwnerAccount});
            await VotingInstance.startVotingSession({from: OwnerAccount});
            

            await VotingInstance.setVote(new BN(0), {from: Account1});
            await VotingInstance.setVote(new BN(1), {from: Account2});
            await VotingInstance.setVote(new BN(1), {from: Account3});
        });

        it("test tallyVotes", async () => {
            await expectRevert(VotingInstance.tallyVotes({from: OwnerAccount}), "Current status is not voting session ended");
            
             await VotingInstance.endVotingSession({from: OwnerAccount});
            
  
            await expectRevert(VotingInstance.tallyVotes({from: Account1}), ErrorOwner);

       
             const findEvent = await VotingInstance.tallyVotes({from: OwnerAccount});

             VotingInstance.winningProposalID().then(function (result) {
                expect(result).to.be.bignumber.equal(new BN(1), "proposal_1 win");
             });

             expectEvent(findEvent, "WorkflowStatusChange", {previousStatus:VotingSessionEnded, newStatus: VotesTallied});
        });

    });
});
