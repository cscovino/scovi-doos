// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ScoviDoosDNA.sol";

contract ScoviDoos is ERC721, ERC721Enumerable, ScoviDoosDNA {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("ScoviDoos", "SCVIDS") {
        maxSupply = _maxSupply;
    }

    function mint() public {
        uint256 current = _idCounter.current();
        require(current < maxSupply, "No ScoviDoos left");
        tokenDNA[current] = deterministicPseudoRandomDNA(current, msg.sender);
        _safeMint(msg.sender, current);
        _idCounter.increment();
    }

    function _baseURI()
        internal
        pure
        override
        returns (string memory)
    {
        return "https://animal-avatar.up.railway.app/";
    }

    function _paramsURI(uint256 _dna)
        internal
        view
        returns (string memory)
    {
        return string(abi.encodePacked(
            "avatarColor=%23",
            getAvatarColor(_dna),
            "&hairColor=%23",
            getHairColor(_dna),
            "&backgroundColor=%23",
            getBackgroundColor(_dna),
            "&pattern=",
            getPatternType(_dna),
            "&ears=",
            getEarsType(_dna),
            "&hair=",
            getHairType(_dna),
            "&muzzle=",
            getMuzzleType(_dna),
            "&eyes=",
            getEyesType(_dna),
            "&brows=",
            getBrowsType(_dna),
            "&round=",
            getIsRound(_dna),
            "&blackout=",
            getIsBlackout(_dna)
        ));
    }

    function imageByDNA(uint256 _dna)
        public
        view
        returns (string memory)
    {
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramsURI(_dna);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721 Metadata: URI query for nonexistent token"
        );

        uint256 dna = tokenDNA[tokenId];
        string memory imageURI = imageByDNA(dna);

        bytes memory json; 
        
        {
            json = abi.encodePacked(
                '{ "name": "ScoviDoos #',
                tokenId.toString(),
                '", "description": "Scovi Doos are randomized animal avatars stored on chain", "image": "',
                imageURI,
                '", "attributes": [',
                '{ "trait_type": "Avatar Color", "value": "#', getAvatarColor(dna),'" },',
                '{ "trait_type": "Hair Color", "value": "#', getHairColor(dna),'" },',
                '{ "trait_type": "Background Color", "value": "#', getBackgroundColor(dna),'" },',
                '{ "trait_type": "Pattern", "value": "', getPatternType(dna),'" },',
                '{ "trait_type": "Ears", "value": "', getEarsType(dna),'" },',
                '{ "trait_type": "Hair", "value": "', getHairType(dna),'" },',
                '{ "trait_type": "Muzzle", "value": "', getMuzzleType(dna),'" },',
                '{ "trait_type": "Eyes", "value": "', getEyesType(dna),'" },'
            );
        }

        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                json,
                '{ "trait_type": "Brows", "value": "', getBrowsType(dna),'" },',
                '{ "trait_type": "Round", "value": "', getIsRound(dna),'" },',
                '{ "trait_type": "Blackout", "value": "', getIsBlackout(dna),'" }',
                ']}'
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
