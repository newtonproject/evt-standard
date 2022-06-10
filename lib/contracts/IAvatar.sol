// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./EVT/IEVT.sol";

interface IAvatar is IEVT  {
    /**
     * @dev Emitted when dynamic property updated.
     */
    event DynamicPropertyUpdated(uint256 tokenId, string propertyId, bytes propertyValue);


    function getPropertyId(string memory propertyName) external view returns (bytes32 propertyId);

     /**
     * @dev Set the `propertyValue` by `tokenId` and `propertyId`.
     * propertyId = bytes32(keccak256('propertyName')) 
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
	// function setBytesDynamicProperty(uint256 tokenId, string memory propertyName, bytes memory propertyValue) external payable;
    // function setUint256DynamicProperty(uint256 tokenId, string memory propertyName, uint256 propertyValue) external payable;	
    // function setBytes32DynamicProperty(uint256 tokenId, string memory propertyName, bytes32 propertyValue) external payable;
    // function setBoolDynamicProperty(uint256 tokenId, string memory propertyName, bool propertyValue) external payable;
    function setStringDynamicProperty(uint256 tokenId, string memory propertyName, string memory propertyValue) external payable;
    // function setAddressDynamicProperty(uint256 tokenId, string memory propertyName, address propertyValue) external payable;
    // function setNewtonAddressDynamicProperty(uint256 tokenId, string memory propertyName, address propertyValue) external payable;

    // function setDynamicProperties(uint256 tokenId, bytes memory message) external override payable;

    /**
     * @dev Returns the properties of the `propertyName` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
	// function getBytesDynamicProperty(uint256 tokenId, string memory propertyName) external view returns (bytes memory propertyValue);
    // function getUint256DynamicProperty(uint256 tokenId, string memory propertyName) external view returns (uint256 propertyValue);
    // function getBytes32DynamicProperty(uint256 tokenId, string memory propertyName) external view returns (bytes32 propertyValue);
    // function getBoolDynamicProperty(uint256 tokenId, string memory propertyName) external view returns (bool propertyValue);
    function getStringDynamicProperty(uint256 tokenId, string memory propertyName) external view returns (string memory propertyValue);
  
    // function getProperties(uint256 tokenId) external view override returns (bytes memory message);

    /**
     * @dev Returns whether the `propertyName` exists.
     */
	function supportsProperty(string memory propertyName) external view returns (bool);
}