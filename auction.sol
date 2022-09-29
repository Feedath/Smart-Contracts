//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract Auction{
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;

    enum State {Started, Running, Ended, Canceled}
    State public auctionState;

    uint increment;
    address payable public highestBidder;
    uint public highestBindingBid;
    mapping (address => uint) public bids;

    constructor(address eoa){
        owner = payable(eoa);
        startBlock = block.number;
        endBlock = startBlock + 40320;
        auctionState = State.Running;
        ipfsHash = "";
        increment = 100;
    }

    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }

    modifier notOwner {
        require (msg.sender != owner);
        _;
    }

    modifier afterStart {
        require (startBlock <= block.number);
        _;
    }

    modifier beforeEnd {
        require (block.number >= endBlock);
        _;
    }

    function min(uint a, uint b) pure internal returns (uint){
        if (a<=b){
            return a;
        }
        else return b;
    }

    function placeBid() public payable notOwner afterStart beforeEnd{
        require(auctionState == State.Running);
        require(msg.value >= 100);

        uint currentBid = bids[msg.sender] + msg.value;
        require (currentBid > highestBindingBid);
        if (currentBid <= bids[highestBidder]){
            highestBindingBid = min(currentBid + 10, bids[highestBidder]);
        }
        else {
            highestBindingBid = min(currentBid, bids[highestBidder]+10);
            highestBidder = payable(msg.sender);
        }
        
        
    }

    function finalizeAuction() public {
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender]>0);
        address payable recipient = payable(msg.sender);
        uint value;

        if(auctionState == State.Canceled){
            value = bids[msg.sender];
        } else {
            if(msg.sender == owner){
                value = highestBindingBid;
            } else {
                if(msg.sender == highestBidder){
                    value = bids[msg.sender] - highestBindingBid;
                } else{
                    value = bids[msg.sender];
                }
            }
        }
        recipient.transfer(value);
        bids[recipient]=0;
    }

    function cancelAuction() public onlyOwner{
        auctionState = State.Canceled;
    }
}

contract AuctionCreator{
    Auction[] public auctionsList;

    function createAuction() public{
        Auction myAuction = new Auction(msg.sender);
        auctionsList.push(myAuction);
    }
}
