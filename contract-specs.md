---
eip: X
title: Encrypted Variable Token Proposal
author: Newton Core Team
type: Standards Track
category: NRC
status: Draft
created: 2022-05-18
discussions-to: https://github.com/newtonproject/NEPs/issues/x
---

# EVT Proposal



## Simple Summary



## Abstract

In recent years,  NFT based applications is blooming by acceleration of ERC-721 standard.

But current standards is still limited to few applicable fields such as digital arts because of the aspects below.

* Privacy and copyright protection.

  Because image, audio, video in NFT is totally opening, some important applications such as digital entertainment, social network, etc. , will be not emerging. 

* Variable Property

  Normally the metadata of NFT is  invariable. It impede the inovation based on blockchain.

* Industry metadata

We propose a new token standard EVT(Encrypted Variable Token) which support the development of encrypted and variable decentralized applications.

In EVT, we category metadata as two parts: static property and variable property.

Common variable properties is as follows:

* time-based property
* position-based property
* function-based property
* oracle-based property
* infusion-based property

Another importan feature of EVT is the traceability. It means that each changes of EVT will be recorded.

By the way, we think only standardization of interface is not enough. So we also propose the industry standard of metadata which is on [metadata specs](metadata-specs.md).




## Motivation
This document aims to guide the EVT's integration and interoperationality with wallet, marketplace, metaverse.



### Caveats



## Rationale



## Specification

EVT will inherit the interfaces of NRC7.

The current implementation of EVT is based on solidity programming language. In Solidity, serialization and deserialization is not built-in. So in  implementation of EVT, protobuf3 is used for the serialization and deserialization of variable properties, 



**Variable Interfaces**



```solidity
interface EVTVariable {

	function setDynamicProperty(uint256 _tokenId, bytes32 _propertyID, bytes _propertyValue) external payable;
	
	function setDynamicProperties(uint256 _tokenId, bytes _message) external payable;
	
	function getProperty(uint256 _tokenId, bytes32 _propertyID) external view returns (bytes);

  function getProperties(uint256 _tokenId) external view returns (bytes);
  
	function supportsProperty(bytes32 _propertyID) external view returns (bool);
}
```

`_propertyID` is calculated by `bytes32(keccak256('propertyName'))`  . 



**Encryption Interfaces**



```solidity
interface EVTEncryption {

	function encrypt(uint256 _tokenId, bytes32 _encryptedKeyID, bytes _encryptedKeyValue) external payable;
	
	function addPermission(uint256 _tokenId, bytes32 _encryptedKeyID, address _owner, uint256 expiredTime) external payable returns(bool);
	
	function removePermission(uint256 _tokenId, bytes32 _encryptedKeyID, address _owner) external returns (bool);

  function hasPermission(uint256 _tokenId, bytes32 _encryptedKeyID, address _owner) external view returns (bool);

  function getEncryptedKeyValue(uint256 _tokenId, bytes32 _encryptedKeyID) external view returns (bytes);
}
```




The **metadata extension** is  for EVT smart contracts.

```solidity
interface EVTMetadata {

    function name() external view returns (string _name);
    
		function description() external view returns (string _description);

		function logo() external view returns (string _logo);

    function symbol() external view returns (string _symbol);
    
    // on-chain tokenURI
    function tokenURI(uint256 _tokenId) external view returns (string memory);
		
    function from() external view returns (string);

    function tax() external view returns (uint);    
}
```



## Implementations

```solidity
contract ODI is EVT {
	string internal avatar3D;
	
	function setDynamicProperty(uint256 _tokenId, bytes4 _propertyID, bytes _propertyValue) external payable {
		...
		avatar3D = string(_propertyValue);
		...
		}
	}
	
	function tokenURI(uint256 tokenId) override public view returns (string memory) {
  	string memory json = Base64.encode(bytes(string(abi.encodePacked('{"avatar3D": "' + avatar3D + '", ..."}'))));
  	return string(abi.encodePacked('data:application/json;base64,', json));
	}
	
	function ODI() public {}
	...
}
```





## Test Cases

TBD



## Backwards Compatibility

TBD



## References

**Standards**

1. [NEP-6](https://neps.newtonproject.org/neps/nep-6/) Basic Token Standard.
1. [NEP-7](https://neps.newtonproject.org/neps/nep-7) Non-Fungible Token Standard.

**Issues**

1. The Original EET Issue.

**Discussions**

**NFT Implementations and Other Projects**



## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
