FILE EXPLORER
MAINTAINED BY REMIX
Zoom outZoom in

Scroll to see all tabs
1234567891011121314151617181920212223242526272829303132333435363738
//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract Crowdfunding{
    mapping (address => uint) public contributions;
    address public admin;
    uint public goal;
    uint public minContribution;
    uint public nuOfContributors;

Clear console
0
listen on all transactions
Search with transaction hash or address
 Welcome to Remix 0.26.3

Your files are stored in indexedDB, 425.87 MB / 2 GB used

You can use this terminal to:
Check transactions details and start debugging.
Execute JavaScript scripts:
 - Input a script directly in the command line interface
 - Select a Javascript file in the file explorer and then run \`remix.execute()\` or \`remix.exeCurrent()\`  in the command line interface
 - Right click on a JavaScript file in the file explorer and then click \`Run\`
The following libraries are accessible:
web3 version 1.5.2
ethers.js
remix
Type the library name to see available commands.
>
