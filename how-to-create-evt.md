# How to create EVT

## Guide

### 1. import package

import EVT lib by copy `lib/contracts/EVT`

TODO: change this to `@evt/evt-lib`

```solidity
import "@openzeppelin/contracts/access/Ownable.sol";
import "./../EVT/EVT.sol";

contract Example is EVT, Ownable {
}
```

### 2. add data type (optional)

Add the type you need in your contract, such as:

`enum Types {Bool, Int256, Uint256, Bytes32, Address, Bytes, String, NewtonAddress}`

Then, add the type function, for `Bool` is as follow:

```
function setBoolDynamicProperty(uint256 tokenId, string memory propertyName, bool propertyValue) external payable;
function getBoolDynamicProperty(uint256 tokenId, string memory propertyName) external view returns (bool propertyValue);
```

refer [lib/contracts/EVT/EVTExample.sol](./lib/contracts/EVT/EVTExample.sol)

### 3. define your own tokenURI

There are many ways to customize your tokenURI, here are some of the common ones：

3.1. Base64

import "Base64.sol" and custom your tokenURI, just like the `tokenURI` in [lib/contracts/EVT/EVTExample.sol](./lib/contracts/EVT/EVTExample.sol)

3.2. updateTokenURI

the `tokenURI` is just uri or ipfs, and the owner can update it. just like the `SecureMovie`.

3.3. refer other token

This tokenURI references the tokenURI of another contract, just like the `SecureMovieTickets`
