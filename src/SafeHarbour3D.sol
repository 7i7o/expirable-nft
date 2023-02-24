// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract SafeHarbour3D is ERC721, ERC721Burnable, AccessControl {
    using Counters for Counters.Counter;

    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _tokenIdCounter;

    uint256 public constant EXPIRE_TIME_IN_SECONDS = 60 * 60 * 24 * 365;
    uint256 public constant SUBSCRIPTION_PRICE = 0.10 ether;

    mapping(uint256 => uint256) public expireTime;

    constructor() ERC721("SafeHarbour3D", "SAFE3") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
    }

    function totalSupply() public view returns (uint256) {
    return _tokenIdCounter.current();
    }

    function safeMint(address to) public onlyRole(MINTER_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();

        require(!_exists(tokenId), "SafeHarbour3D: invalid token ID");

        _safeMint(to, tokenId);

        expireTime[tokenId] = block.timestamp + EXPIRE_TIME_IN_SECONDS;  
    }

    function addOneYearOfSubscription(uint256 tokenId) public payable {
        require(_exists(tokenId), "SafeHarbour3D: invalid token ID");
        require(ownerOf(tokenId) == msg.sender, "SafeHarbour3D: not the owner");
        require(msg.value == SUBSCRIPTION_PRICE, "SafeHarbour3D: not the owner");

        // expireTime[tokenId] = block.timestamp + EXPIRE_TIME_IN_SECONDS;

        uint256 previousExpireTime = expireTime[tokenId];

        if (previousExpireTime > block.timestamp) {
            // NFT Expires in the future
            expireTime[tokenId] = previousExpireTime + EXPIRE_TIME_IN_SECONDS;
        } else {
            // NFT is expired
            expireTime[tokenId] = block.timestamp + EXPIRE_TIME_IN_SECONDS;
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        bool isExpired = block.timestamp > expireTime[tokenId];

        if (isExpired) {
            string memory json = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            " #",
                            Strings.toString(tokenId),
                            '", "description": "SafeHarbour3D collection",'
                            '"image": "https://gateway.pinata.cloud/ipfs/QmbDa2gvDrXnb31N4xsAPtARpNsAY4MCcBcuAPyz3t3wab","attributes":[{"trait_type":"Expired","value":"true"}]}'
                        )
                    )
                )
            );

            return
                string(abi.encodePacked("data:application/json;base64,", json));

        } else {
            string memory json = Base64.encode(
                bytes(
                    string(
                        abi.encodePacked(
                            '{"name": "',
                            name(),
                            " #",
                            Strings.toString(tokenId),
                            '", "description": " collection",'
                            '"image": "https://gateway.pinata.cloud/ipfs/QmaX61W1rbRquMzGjWs4CKFXtRjYhHEsNdtXGV45QZQ7nV","attributes":[{"trait_type":"Expired","value":"false"}]}'
                        )
                    )
                )
            );

            return
                string(abi.encodePacked("data:application/json;base64,", json));
        }
    }    

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) public virtual override(ERC721Burnable){
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
        _burn(tokenId);
    }
}

// Thirdweb: https://thirdweb.com/goerli/0x277c8D16d9f7597A70A61533e76e3B4977a1c0dB/

// Optimism Thirdweb: https://thirdweb.com/optimism/0xC2E94C207E9838e0d91692D81956A194dC51FCF5/explorer


