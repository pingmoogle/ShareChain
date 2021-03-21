// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract ShareChain{
    // struct strategy{
    //     uint strategyID;
    //     uint expiretime;
    // }

    struct aShare{
        uint shareID;
        address fileOwner;
        address fileReveiver;
        string fileHash;
        string preKeyToYou;
        // mapping(uint => strategy) thisStrategy;
    }

    mapping(address => uint[]) public userToShares;

    uint public allSharesNum;
    aShare[] public allShares;
    
    constructor(){
        allSharesNum = 0;
    }

    function uploadShare(
        address thefileReceiver, string memory thefileHash, string memory thepreKeyToYou
    ) public{
        uint nowID = allSharesNum++;
        allShares.push(
            aShare({
                shareID: nowID,
                fileOwner: msg.sender,
                fileHash: thefileHash,
                fileReveiver: thefileReceiver,
                preKeyToYou: thepreKeyToYou
            })
        );
        userToShares[thefileReceiver].push(nowID);
    }

    function requestShare() public view returns(uint[] memory t){
        t = userToShares[msg.sender];
    }

    // function showOneShare(uint id) public view returns(thisShare memory ts){
    //     require(id < allSharesNum, "No this Share info");
    //     struct thisShare {
    //         uint shareID;
    //         address fileOwner;
    //         address fileReveiver;
    //         string fileHash;
    //     }
    //     thisShare memory ts;
    //     ts.shareID = allShares[id].shareID;
    //     ts.fileOwner = allShares[id].fileOwner;
    //     ts.fileReveiver = allShares[id].fileReveiver;
    //     ts.fileHash = allShares[id].fileHash;
    // }
    
    function showOneShare(uint id) view public returns (aShare memory ts){
        require(id < allSharesNum, "No this Share info");
        ts = allShares[id];
        
    }

}