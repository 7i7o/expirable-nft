// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Moonlight is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    mapping (uint256 => string) private _tokenName;
    mapping (uint256 => string) private _tokenDescription;
    mapping (uint256 => string) private _tokenBTCAddress;

    constructor() ERC721("Moonlight","MOON") {}

    function mintNFT(address recipient, string memory tokenURI, string memory name, string memory description, string memory btcAddress) public returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);
        
        _tokenName[newItemId] = name;
        _tokenDescription[newItemId] = description;
        _tokenBTCAddress[newItemId] = btcAddress;

        return newItemId;
    }

    function _requireMinted(uint256 tokenId) internal view override {
        require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
    }

    function getTokenName(uint256 tokenId) public view returns (string memory) {
        _requireMinted(tokenId);
        return _tokenName[tokenId];
    }

    function getTokenDescription(uint256 tokenId) public view returns (string memory) {
        _requireMinted(tokenId);
        return _tokenDescription[tokenId];
    }

    function getTokenBTCAddress(uint256 tokenId) public view returns (string memory) {
        _requireMinted(tokenId);
        return _tokenBTCAddress[tokenId];
    }
}

