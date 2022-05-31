// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEVTVariable {
    /**
     * @dev Emitted when dynamic property updated.
     */
    event DynamicPropertyUpdated(uint256 tokenId, bytes32 propertyId, bytes propertyValue);


     /**
     * @dev Set the `propertyValue` by `tokenId` and `propertyId`.
     * propertyId = bytes32(keccak256('propertyName')) 
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
	function setDynamicProperty(uint256 tokenId, bytes32 propertyId, bytes memory propertyValue) external payable;
	
	function setDynamicProperties(uint256 tokenId, bytes memory message) external payable;

    /**
     * @dev Returns the properties of the `propertyId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
	function getDynamicProperty(uint256 tokenId, bytes32 propertyId) external view returns (bytes memory propertyValue);

    function getDynamicProperties(uint256 tokenId) external view returns (bytes memory message);
  
    /**
     * @dev Returns whether the `propertyId` exists.
     */
	function supportsProperty(bytes32 propertyId) external view returns (bool);
}
