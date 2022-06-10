// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./EVT/EVT.sol";
import "./libraries/base64.sol";
import "./IAvatar.sol";

contract Avatar is EVT, Ownable, IAvatar {
	using Counters for Counters.Counter;

	Counters.Counter private _tokenIdCounter;

    enum Types {String}

    mapping(bytes32 => string) private _properties;
    mapping(bytes32 => Types) private _propertiesTypes;

	string public constant AvatarName = "Avatar";

	constructor() EVT("Avatar", "AVATAR") {
		addDynamicProperty(AvatarName, Types.String);
	}

    /////////////////////// Utils ///////////////////////
    function getPropertyId(string memory propertyName) public view virtual override returns (bytes32 propertyId) {
        return keccak256(abi.encode(propertyName));
    }

    function addDynamicProperty(string memory propertyName, Types propertyType) public virtual returns (bool) {
        bytes32 propertyId = getPropertyId(propertyName);
        _propertiesTypes[propertyId] = propertyType;
        // EVTVariable.addDynamicProperty(propertyId); // TODO: 
        return true;
    }

    function setStringDynamicProperty(uint256 tokenId, string memory propertyName, string memory propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.String, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }

    function getStringDynamicProperty(uint256 tokenId, string memory propertyName) 
        public virtual override view returns (string memory propertyValue) {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.String, "property type error");
        return abi.decode(EVTVariable.getProperty(tokenId, propertyId), (string));
    }

    function supportsProperty(string memory propertyName) public view override returns (bool) {
        bytes32 propertyId = getPropertyId(propertyName);
        return  EVTVariable.supportsProperty(propertyId);
    }


    /////////////////////// AvatarDemo ///////////////////////
    function mint(string memory avatarURI) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
		setStringDynamicProperty(tokenId, AvatarName, avatarURI);
    }

	function mint() public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }


	function updateAvatar(uint256 tokenId, string memory uri) public {
		require(ownerOf(tokenId) == msg.sender, "Caller not owner");
		setStringDynamicProperty(tokenId, AvatarName, uri);
	}
   
    function getDynamicPropertiesArray(uint256 tokenId) public view virtual returns(string[] memory properties) {
        (bytes32[] memory ids, bytes[] memory values) = EVTVariable.getAll(tokenId);
        require(ids.length == values.length, "length error");
        properties = new string[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            string memory args = string(abi.encodePacked('{"trait_type":"', _properties[id], '","value":'));
            if (_propertiesTypes[id] == Types.String) {
                (string memory value) = abi.decode(values[i], (string));
                args = string(abi.encodePacked(args, '"', value, '"'));
            } else {
                args = string(abi.encodePacked(args, '"', string(values[i]), '"'));
            }
            
            args = string(abi.encodePacked(args, '}'));


            properties[i] = string(args);
        }
    }

    function getDynamicPropertiesAsString(uint256 tokenId) public view virtual returns(string memory properties) {
        string[] memory args = getDynamicPropertiesArray(tokenId);
        properties = '[';
        for (uint256 i = 0; i < args.length; i++) {
            if (i + 1 == args.length) {
                properties = string(abi.encodePacked(properties, args[i]));
            } else {
                properties = string(abi.encodePacked(properties, args[i], ','));
            }
        }
        properties = string(abi.encodePacked(properties, ']'));
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
	

