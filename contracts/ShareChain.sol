// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

contract ShareChain{

    struct Frag{
        uint fragType; // 0 for c, 1 for k
        string fragContent;
        address fragOwner;
    }

    struct aShare{
        uint shareID;
        address fileOwner;
        address fileReveiver;
        string fileHash;
        string fileKey;
        string capsule;
    }

    event shareEvent(
        address indexed fileOwner,
        address indexed fileReceiver,
        string indexed fileHash,
        uint  id
    );

    mapping(uint => Frag[]) public shareToFrags;
    mapping(address => uint[]) public userToShares;

    uint public allSharesNum;
    aShare[] public allShares;
    
    constructor(){
        allSharesNum = 0;
    }

    function uploadShare(
        address thefileReceiver, string memory thefileHash, string memory thefileKey,
        string memory theCapsule, string memory cFrag0
    ) public returns (uint nowID){
        nowID = allSharesNum++;
        Frag memory af = Frag({
            fragType: 0,
            fragContent: cFrag0,
            fragOwner: msg.sender
        });
        shareToFrags[nowID].push(af);
        aShare memory itShare;
        itShare.shareID = nowID;
        itShare.fileOwner = msg.sender;
        itShare.fileHash = thefileHash;
        itShare.fileReveiver = thefileReceiver;
        itShare.fileKey = thefileKey;
        itShare.capsule = theCapsule;

        allShares.push(itShare);
        userToShares[thefileReceiver].push(nowID);

        emit shareEvent(msg.sender, thefileReceiver, thefileHash, nowID);
    }

    function uploadFrags(uint ID, uint fragType, string memory frag, address fragOwner)
    public {
        require(allShares[ID].fileOwner == msg.sender, "You are not the file owner.");
        Frag memory af = Frag({
            fragType: fragType,
            fragContent: frag,
            fragOwner: fragOwner
        });
        shareToFrags[ID].push(af);
    }

    function updateFrags(uint ID, uint fragType, string memory frag)
    public {
        uint existThisAddress = 0;
        uint location = 0;
        for (uint loop = 0; loop < shareToFrags[ID].length; loop++){
            if(shareToFrags[ID][loop].fragOwner == msg.sender){
                existThisAddress = 1;
                location = loop;
                break;
            }
        }
        require(existThisAddress == 1, "You are not the frag owner");
        shareToFrags[ID][location].fragType = fragType;
        shareToFrags[ID][location].fragContent = frag;
    }

    function requestShare() public view returns(uint[] memory t){
        t = userToShares[msg.sender];
    }
    
    function showOneFrags(uint id) view public returns (Frag[] memory sf){
        require(id < allSharesNum, "No this Share info");
        sf = shareToFrags[id];
    }

    function showOneShare(uint id) view public returns (aShare memory ts){
        require(id < allSharesNum, "No this Share info");
        ts = allShares[id];
    }

    
}