// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.8.4 <0.9.0;

interface EVTVariable {
  /// @notice Decode key.
  /// @param p Position
  /// @param buf Buffer
  /// @return Success
  /// @return New position
  /// @return Field number
  /// @return Wire type
  function setDynamicProperty(uint256 _tokenId, bytes32 _propertyID, bytes _propertyValue) external payable;

  /// @notice Decode key.
  /// @param p Position
  /// @param buf Buffer
  /// @return Success
  /// @return New position
  /// @return Field number
  /// @return Wire type	
  function setDynamicProperties(uint256 _tokenId, bytes _message) external payable;
	
  /// @notice Decode key.
  /// @param p Position
  /// @param buf Buffer
  /// @return Success
  /// @return New position
  /// @return Field number
  /// @return Wire type
  function getProperty(uint256 _tokenId, bytes32 _propertyID) external view returns (bytes);

  function getProperties(uint256 _tokenId) external view returns (bytes);
  
  function supportsProperty(bytes32 _propertyID) external view returns (bool);
}

interface EVTEncryption {

  function encrypt(uint256 _tokenId, bytes32 _encryptedPropertyID, bytes _encryptedPropertyValue) external payable;
	
  function addPermission(uint256 _tokenId, bytes32 _encryptedPropertyID, address _owner, uint256 expiredTime) external payable returns(bool);
	
  function removePermission(uint256 _tokenId, bytes32 _encryptedPropertyID, address _owner) external returns (bool);

  function hasPermission(uint256 _tokenId, bytes32 _encryptedPropertyID, address _owner) external view returns (bool);

  function getEncryptedKeyValue(uint256 _tokenId, bytes32 _encryptedPropertyID) external view returns (bytes);
}

interface EVTMetadata {

  function name() external view returns (string _name);
    
  function description() external view returns (string _description);

  function logo() external view returns (string _logo);

  function symbol() external view returns (string _symbol);
    
  // on-chain tokenURI
  function tokenURI(uint256 _tokenId) external view returns (string memory);
		
  function from() external view returns (string);
}
