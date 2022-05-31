// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IEVTEncryption {

	function encrypt(uint256 tokenId, bytes32 encryptedKeyID, bytes memory encryptedKeyValue) external payable;
	
	function addPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner, uint256 expiredTime) external payable returns(bool);
	
	function removePermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) external returns (bool);

    function hasPermission(uint256 tokenId, bytes32 encryptedKeyID, address owner) external view returns (bool);

    function getEncryptedKeyValue(uint256 tokenId, bytes32 encryptedKeyID) external view returns (bytes memory);
}
