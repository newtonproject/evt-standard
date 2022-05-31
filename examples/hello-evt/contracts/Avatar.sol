// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./EVT/EVT.sol";

contract AvatarDemo is EVT, Ownable {
	using Counters for Counters.Counter;

	Counters.Counter private _tokenIdCounter;

	string public constant Avatar = "Avatar";

	constructor() EVT("AvatarDemo", "AVATAR") {
		addDynamicProperty(Avatar, Types.String);
	}

	function mint() public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }

	function mint(string memory avatarURI) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
		setStringDynamicProperty(tokenId, Avatar, avatarURI);
    }

	function updateAvatar(uint256 tokenId, string memory uri) public {
		require(ownerOf(tokenId) == msg.sender, "Caller not owner");
		setStringDynamicProperty(tokenId, Avatar, uri);
	}
   
   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string[17] memory args;
        args[0] = '{"name": "';
        args[1] = symbol();
        args[2] = ' # ';
        args[3] = Strings.toString(tokenId);
        args[4] = '", "description": " The EVT of ';
        args[5] = name();
        args[6] = ' by Newton.", "image": "ipfs://QmRHrWJxfc1ahV1pQ5wczQ6jEBuabfKKTBWC1RvoZXoy8W", "attributes":';
        args[7] = getDynamicPropertiesAsString(tokenId);
        args[8] = '}';
       
        string memory json = Base64.encode(bytes(string(abi.encodePacked(
            args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]
        ))));
    
        return string(abi.encodePacked('data:application/json;base64,', json));
    }
}
	

