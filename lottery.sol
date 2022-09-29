//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    
    address payable[] public players;
    address public manager;
    
    
    constructor(){
        manager = msg.sender;
        players.push(payable(manager));
    }
    
    receive () payable external{
        require(msg.value == 0.1 ether);
        require(msg.sender != manager);
        players.push(payable(msg.sender));
    }
    
    function getBalance() internal view returns(uint){
        return address(this).balance;
    }
    
    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    
    function pickWinner() public{
        require (players.length >= 10);

        uint commission = 10*getBalance()/100;
        payable(manager).transfer(commission);
        
        uint r = random();
        address payable winner;
        
        uint index = r % players.length;
    
        winner = players[index];
        
        winner.transfer(getBalance());
        
        players = new address payable[](0);

        players.push(payable(manager));
    }

}
