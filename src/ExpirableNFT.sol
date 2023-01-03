// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ExpirableNFT is ERC721 {

    uint256 public constant EXPIRE_TIME_IN_SECONDS = 60 * 60 * 24 * 365;
    uint256 public constant SUBSCRIPTION_PRICE = 1 ether;
    
    mapping(uint256 => uint256) public expireTime;

    constructor() ERC721("ExpirableNFT", "EXP") {}

    function mint(uint256 tokenId) external {
        require(!_exists(tokenId), "ExpirableNFT: invalid token ID");

        _safeMint(msg.sender, tokenId);

        expireTime[tokenId] = block.timestamp + EXPIRE_TIME_IN_SECONDS;
    }

    function addOneYearOfSubscription(uint256 tokenId) public payable {
        require(!_exists(tokenId), "ExpirableNFT: invalid token ID");
        require(ownerOf(tokenId) == msg.sender, "ExpirableNFT: not the owner");
        require(msg.value == SUBSCRIPTION_PRICE, "ExpirableNFT: not the owner");

        expireTime[tokenId] = block.timestamp + EXPIRE_TIME_IN_SECONDS;
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
                            '", "description": "ExpirableNFT collection",'
                            '"image": "https://gateway.pinata.cloud/ipfs/QmaX61W1rbRquMzGjWs4CKFXtRjYhHEsNdtXGV45QZQ7nV","attributes":[{"trait_type":"Expired","value":"true"}]}'
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
                            '", "description": "ExpirableNFT collection",'
                            '"image": "https://gateway.pinata.cloud/ipfs/QmaX61W1rbRquMzGjWs4CKFXtRjYhHEsNdtXGV45QZQ7nV","attributes":[{"trait_type":"Expired","value":"false"}]}'
                        )
                    )
                )
            );

            return
                string(abi.encodePacked("data:application/json;base64,", json));
        }
    }
}
