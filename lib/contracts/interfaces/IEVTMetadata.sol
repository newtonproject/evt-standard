// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

interface IEVTMetadata is IERC721Metadata{
    /**
     * @dev Returns the token collection name.
     */
    function name() external view override returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view override returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     * This is on-chain tokenURI.
     */
    function tokenURI(uint256 tokenId) external view override returns (string memory);
    
	function description() external view returns (string memory);

	function logo() external view returns (string memory);
		
    function from() external view returns (string memory);

    function tax() external view returns (uint);    
}
