// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./EVT.sol";
import "./IEVTExample.sol";
import "./extensions/EVTVariable.sol";
import "../libraries/HexStrings.sol";
import "../libraries/NewtonAddress.sol";
import "../libraries/base64.sol";

contract EVTExample is ERC165, EVT, IEVTExample {
    enum Types {Bool, Int256, Uint256, Bytes32, Address, Bytes, String, NewtonAddress}

    mapping(bytes32 => string) private _properties;
    mapping(bytes32 => Types) private _propertiesTypes;

    constructor(string memory name_, string memory symbol_) EVT(name_, symbol_) {}

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165, EVT) returns (bool) {
        return interfaceId == type(IEVTExample).interfaceId || super.supportsInterface(interfaceId);
    }

    function getPropertyId(string memory propertyName) public view virtual override returns (bytes32 propertyId) {
        return keccak256(abi.encode(propertyName));
    }

    function addDynamicProperty(string memory propertyName, Types propertyType) public virtual returns (bool) {
        bytes32 propertyId = getPropertyId(propertyName);
        _propertiesTypes[propertyId] = propertyType;
        // EVTVariable.addDynamicProperty(propertyId); // TODO: 
        return true;
    } 

    function setBytesDynamicProperty(uint256 tokenId, string memory propertyName, bytes memory propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Bytes, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, propertyValue);
    }
    function setUint256DynamicProperty(uint256 tokenId, string memory propertyName, uint256 propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Uint256, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }
    function setBytes32DynamicProperty(uint256 tokenId, string memory propertyName, bytes32 propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Bytes32, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }
    function setBoolDynamicProperty(uint256 tokenId, string memory propertyName, bool propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Bool, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }
    function setStringDynamicProperty(uint256 tokenId, string memory propertyName, string memory propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.String, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }
    function setAddressDynamicProperty(uint256 tokenId, string memory propertyName, address propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Address, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }
    function setNewtonAddressDynamicProperty(uint256 tokenId, string memory propertyName, address propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.NewtonAddress, "property type error");
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }

    function setDynamicProperties(uint256 tokenId, bytes memory message) public virtual override(IEVTExample, EVTVariable) payable {
        // TODO:
    }
    
	function getBytesDynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override returns (bytes memory) {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Bytes, "property type error");
        return EVTVariable.getProperty(tokenId, propertyId);
    }
    function getUint256DynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override returns (uint256 propertyValue) {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Uint256, "property type error");
        propertyValue = abi.decode(EVTVariable.getProperty(tokenId, propertyId), (uint256));
    }
    function getBytes32DynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override returns (bytes32 propertyValue) {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Bytes32, "property type error");
        propertyValue = abi.decode(EVTVariable.getProperty(tokenId, propertyId), (bytes32));
    }
    function getBoolDynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override returns (bool propertyValue) {
        bytes32 propertyId = getPropertyId(propertyName);
        require(_propertiesTypes[propertyId] == Types.Bool, "property type error");
        propertyValue = abi.decode(EVTVariable.getProperty(tokenId, propertyId), (bool));
    }

    function getProperties(uint256 tokenId) public view virtual override(IEVTExample, EVTVariable) returns (bytes memory message) {
        // TODO:
    }

	function supportsProperty(string memory propertyName) public view virtual override returns (bool) {
        bytes32 propertyId = getPropertyId(propertyName);
        return EVTVariable.supportsProperty(propertyId);
    }

    function getDynamicPropertiesArray(uint256 tokenId) public view virtual returns(string[] memory properties) {
        (bytes32[] memory ids, bytes[] memory values) = EVTVariable.getAll(tokenId);
        require(ids.length == values.length, "length error");
        properties = new string[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            bytes32 id = ids[i];
            string memory args = string(abi.encodePacked('{"trait_type":"', _properties[id], '","value":'));
            if (_propertiesTypes[id] == Types.Bool) {
                (bool value) = abi.decode(values[i], (bool));
                if (value) {
                    args = string(abi.encodePacked(args, '"true"'));
                } else {
                    args = string(abi.encodePacked(args, '"false"'));
                }
            } else if (_propertiesTypes[id] == Types.Int256) {
                (int256 value) = abi.decode(values[i], (int256));
                if (value >= 0) {
                    args = string(abi.encodePacked(args, Strings.toString(uint256(value))));
                } else {
                    args = string(abi.encodePacked(args, '-', Strings.toString(uint256(-value))));
                }
            } else if (_propertiesTypes[id] == Types.Uint256) {
                (uint256 value) = abi.decode(values[i], (uint256));
                args = string(abi.encodePacked(args, Strings.toString(value)));
            } else if (_propertiesTypes[id] == Types.Bytes32) {
                (bytes32 value) = abi.decode(values[i], (bytes32));
                args = string(abi.encodePacked(args, '"', HexStrings.toHexStringNoPrefix(uint256(value), 32), '"'));
            } else if (_propertiesTypes[id] == Types.Address) {
                (address value) = abi.decode(values[i], (address));
                args = string(abi.encodePacked(args, '"', HexStrings.toHexString(uint256(uint160(value)), 20), '"'));
            } else if (_propertiesTypes[id] == Types.Bytes) {
                (bytes memory value) = abi.decode(values[i], (bytes));
                args = string(abi.encodePacked(args, '"', string(value), '"'));
            } else if (_propertiesTypes[id] == Types.String) {
                (string memory value) = abi.decode(values[i], (string));
                args = string(abi.encodePacked(args, '"', value, '"'));
            } else if (_propertiesTypes[id] == Types.NewtonAddress) {
                (address value) = abi.decode(values[i], (address));
                args = string(abi.encodePacked(args, '"', NewtonAddress.hex2New(value), '"'));
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

    /**
     * {"name":"SYMBOL #1", "description": "Name #1", "image": "ipfs://hash",
        "attributes": [
        ]}
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        string[17] memory args;
        args[0] = '"name": "';
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
