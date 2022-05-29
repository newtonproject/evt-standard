---
eip: X
title: Encryption and Evolution Token Standard
author: NewChain Newton
type: Standards Track
category: ERC
status: Draft
created: 2022-05-18
discussions-to: https://github.com/newtonproject/NEPs/issues/x
---

# EVT Standard



## Simple Summary



## Abstract

近年来，以太坊上的ERC-721, ERC-1155等标准极大推动了NFT和区块链产业的发展。

不过，当前的标准也存在如下的严重不足：

* NFT中的图片、视频、音频等数字媒体资源都是完全公开的，没有对应的隐私和版权保护设计；
* 在ERC721和ERC1155标准中，NFT的metadata是不可变成，严重限制了应用的创新；

EVT(Encryption and Variable Token)是可加密、可变化的代币标准， a new kind of token。

EVT为元宇宙而生。

NFT是EVT的子集。

举例：

* 元宇宙里面的砖要有一个标准；



不可变属性：

* symbol
* name



可变属性包括：

* 基于时间
* 基于位置
* 基于功能
* 基于Oracle
* 组合
* ODI



TODO：可记录属性的状态。




## Motivation
本文档中涉及的接口标准用于钱包、NFT Marketplace、Metaverse中EVT代币互操作。



### Caveats



## Rationale



## Specification



**NewInfo schemes**

```bash
newinfo://[version]@[Random Token ID]
```

For example, `newinfo://v1@123...` .

IPFS://Qxxx



**EVT Interfaces**

```solidity
interface EVT /* is NRC7 */{
	function setDynamicProperty(uint256 _tokenId, bytes32 _propertyID, string _propertyValue) external payable;
	function getDynamicProperty(uint256 _tokenId, bytes32 _propertyID) external view returns (string);
    function getStaticProperty(uint256 _tokenId, bytes32 _propertyID) external view returns (string);
    function tokenURI(uint256 _tokenId) external view returns (string);
    function updateTokenURI(uint256 _tokenId, string uri) external;
	function supportsProperty(bytes32 _propertyID) external view returns (bool);
}

interface EVTPolicy {
	function addRole(uint256 _tokenId, bytes32 _propertyID, address _owner) external;
	function removeRole(uint256 _tokenId, bytes32 _propertyID, address _owner) external;
	function isAuth(uint256 _tokenId, bytes32 _propertyID, address _owner) external view returns (bool);
}
```

`_propertyID` is calculated by `bytes32(keccak256('propertyName(uint256)'));`. For example, `bytes32(keccak256('position(uint256)'))` .



The **metadata extension** is  for EVT smart contracts.

```solidity
interface EVTMetadata /* is EVT */ {
    function name() external view returns (string _name);
    
		function description() external view returns (string _description);

		function logo() external view returns (string _logo);

    function symbol() external view returns (string _symbol);
    
    function tokenURI(uint256 _tokenId) external view returns (string);
		
    function from() external view returns (string);

    function tax() external view returns (uint);
    
    function dynamicProperties() external view returns (bytes32[]);
}
```



**Common Dynamic Property**

| Property Name | Description |
| ------------- | ----------- |
| expired       |             |
| position      |             |
| lockContent   |             |
| newinfoUri    |             |



**ODI Dynamic Property**

| Property Name | Description |
| ------------- | ----------- |
| avatar3D      |             |
|               |             |
|               |             |



from dynamic to fixed

ROM readonly, solid property

RAM random access,  liquid property



## Implementations

```solidity
contract ODI is EVT {
	string internal _avatar3D;
	
	function avatar3D(uint256 _tokenId) internal view returns (string){
		return _avatar3D;
	}
	
	function setDynamicProperty(uint256 _tokenId, bytes4 _propertyID, string _propertyValue) external payable {
		if (_propertyID == this.avatar3D.selector) {
			_avatar3D = _propertyValue;
		}
	}
	
	function ODI() public {}
	...
}
```





## Test Cases

TBD



## Backwards Compatibility

TBD



## Use Cases

* 养一盆花

  用例

  * 点一下按钮，换一张图；

  

  callFunction('token_id', 'water', value)

  ​	-> property: health

  ​		

* ODI

  Original Digital Identity

  sp1: 2D人物

  sp2: 3D人物

​		要求：技术手段实现一致性；不需要法律授权；

​		

​		setDynamicProperty('3davatar', 'uri')

​		key metadata:

​			people

​			masterials

​		

​		以后，可以在metaverse、社交媒体使用。

​		知道历史所有“头像”。

​		



* 电影

​		过期时间

​		

* 人物角色

​		cat from birth to mature, facial changes, has children, health status, emtion

​		dynamic property

​				age

​				children

​				health

​		callFunction('feed', 'xxxx', value)

​		callFunction('walk', 'xxxx', value)

​		

* 版权交易



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
