// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "./EVTVariable.sol";
import "../../interfaces/IEVTVariableReadable.sol";

/**
 * @dev This implements an optional extension of {EVT} that adds dynamic properties.
 */
abstract contract EVTVariableReadable is EVTVariable, IEVTVariableReadable {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // List of propertie ids
    // EnumerableSet.Bytes32Set private _propertieIds;

    // Mapping tokenId ==> propertieId ==> propertieValue
    // mapping(uint256 => mapping(bytes32 => bytes)) private _properties;
    mapping(bytes32 => string) private _properties;
    mapping(bytes32 => uint256) private _propertiesType;    // emnu


    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, EVTVariable) returns (bool) {
        return interfaceId == type(IEVTVariableReadable).interfaceId || super.supportsInterface(interfaceId);
    }

    function getPropertyId(string memory propertyName) public view virtual override returns (bytes32 propertyId) {
        return keccak256(abi.encode(propertyName));
    }

    function addDynamicProperty(string memory propertyName, ) public virtual returns (bool) {
        bytes32 propertyId = getPropertyId(propertyName);
        _propertieIds.add(propertyId);
        // EVTVariable.addDynamicProperty(propertyId); // TODO: 
        return true;
    } 

    function setBytesDynamicProperty(uint256 tokenId, string memory propertyName, bytes memory propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, propertyValue);
    }
    function setUint256DynamicProperty(uint256 tokenId, string memory propertyName, uint256 propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }
    function setBytes32DynamicProperty(uint256 tokenId, string memory propertyName, bytes32 propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }
    function setBoolDynamicProperty(uint256 tokenId, string memory propertyName, bool propertyValue) public virtual override payable {
        bytes32 propertyId = getPropertyId(propertyName);
        _properties[propertyId] = propertyName;
        EVTVariable.setDynamicProperty(tokenId, propertyId, abi.encode(propertyValue));
    }

    function setDynamicProperties(uint256 tokenId, bytes memory message) public virtual override(EVTVariable, IEVTVariableReadable) payable {
        // TODO:
    }
    
	function getBytesDynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override(IEVTVariableReadable) returns (bytes memory) {
        return EVTVariable.getDynamicProperty(tokenId, getPropertyId(propertyName));
    }
    function getUint256DynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override(IEVTVariableReadable) returns (uint256 propertyValue) {
        propertyValue = abi.decode(EVTVariable.getDynamicProperty(tokenId, getPropertyId(propertyName)), (uint256));
    }
    function getBytes32DynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override(IEVTVariableReadable) returns (bytes32 propertyValue) {
        propertyValue = abi.decode(EVTVariable.getDynamicProperty(tokenId, getPropertyId(propertyName)), (bytes32));
    }
    function getBoolDynamicProperty(uint256 tokenId, string memory propertyName) public view virtual override(IEVTVariableReadable) returns (bool propertyValue) {
        propertyValue = abi.decode(EVTVariable.getDynamicProperty(tokenId, getPropertyId(propertyName)), (bool));
    }

    function getDynamicProperties(uint256 tokenId) public view virtual override(EVTVariable, IEVTVariableReadable) returns (bytes memory message) {
        // TODO:
    }

	function supportsProperty(string memory propertyName) public view virtual override(IEVTVariableReadable) returns (bool) {
        bytes32 propertyId = getPropertyId(propertyName);
        return EVTVariable.supportsProperty(propertyId);
    }

    // 
    function getAllAsString(uint256 tokenId) public view virtual returns(string[] memory properties) {
        (bytes32[] memory ids, bytes[] memory values) = EVTVariable.getAll(tokenId);
        require(ids.length == values.length, "length error");
        properties = new string[](ids.length);
        for (uint256 i = 0; i < ids.length; i++) {
            string memory property = string(abi.encodePacked('{"trait_type":"', _properties[ids[i]], '","value":', '}'));


            properties[i] = property;
        }
    }
}