// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScoviDoosDNA {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    string[] private _patternType = [
        "jawPattern",
        "rightEyePattern",
        "leftEyePattern"
    ];

    string[] private _earsType = [
        "prickEars",
        "buttonEars",
        "roseEars",
        "cowEars",
        "heartShapeEars",
        "bearEars",
        "reindeerEars",
        "foldedEars",
        "ellipseEars",
        "batEars",
        "deerEars",
        "giraffeEars",
        "goatEars",
        "mouseEars"
    ];

    string[] private _hairType = [
        "curlyHair",
        "fringeHair",
        "palmTreeHair",
        "crestHair"
    ];

    string[] private _muzzleType = [
        "tongueMuzzle",
        "whiteNeutralMuzzle",
        "bullMuzzle",
        "smallTongueMuzzle",
        "smallSmileyMuzzle",
        "smileyWhiteMuzzle",
        "worriedMuzzle",
        "boarMuzzle",
        "hippoMuzzle",
        "sideSmileyMuzzle",
        "catMuzzle",
        "neutralMuzzle",
        "sealMuzzle",
        "smileyMuzzle",
        "horseMuzzle",
        "monkeyMuzzle"
    ];

    string[] private _eyesType = [
        "brightEyes",
        "downEyes",
        "upEyes",
        "brighterEyes",
        "twoSideEyes",
        "triangleEyes",
        "leftEyes",
        "distantLeftEyes"
    ];

    string[] private _browsType = [
        "ellipseBrows",
        "rectBrows",
        "arcBrows"
    ];

    string[] private _isRound = [
        "true",
        "false"
    ];

    string[] private _isBlackout = [
        "true",
        "false"
    ];

    function deterministicPseudoRandomDNA(uint256 _tokenId, address _minter)
        public
        pure
        returns (uint256)
    {
        uint256 combinedParams = _tokenId + uint160(_minter);
        bytes memory encodedParams = abi.encodePacked(combinedParams);
        bytes32 hasedParams = keccak256(encodedParams);

        return uint256(hasedParams);
    }

    // Get attributes
    function _getDNASection(uint256 _dna, uint8 _dnaSectionSize, uint8 _rightDiscard)
        internal
        pure
        returns (uint32)
    {
        return uint32(
            (_dna % (1 * 10 ** (_rightDiscard + _dnaSectionSize))) /
                (1 * 10 ** _rightDiscard)
        );
    }

    // Modified function from @openzeppelin/contracts/utils/Strings.sol
    function _toHexString(uint256 value)
        internal
        pure
        returns (string memory)
    {
        if (value == 0) {
            return "00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        bytes memory buffer = new bytes(2 * length);
        for (uint256 i = 2 * length - 1; i > 0; i--) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        buffer[0] = _HEX_SYMBOLS[value & 0xf];
        return string(buffer);
    }

    function _uint256ToHexColorStr(uint256 number)
        private
        pure
        returns (string memory)
    {
        // 16777215 max decimal number for hex color #FFFFFF
        return _toHexString(number % 16777215);

    }
    
    function getAvatarColor(uint256 _dna)
        public
        pure
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 8, 0);
        return _uint256ToHexColorStr(dnaSection);
    }
    
    function getHairColor(uint256 _dna)
        public
        pure
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 8, 8);
        return _uint256ToHexColorStr(dnaSection);
    }
    
    function getBackgroundColor(uint256 _dna)
        public
        pure
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 8, 16);
        return _uint256ToHexColorStr(dnaSection);
    }

    function getPatternType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 24);
        return _patternType[dnaSection % _patternType.length];
    }

    function getEarsType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 26);
        return _earsType[dnaSection % _earsType.length];
    }

    function getHairType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 28);
        return _hairType[dnaSection % _hairType.length];
    }

    function getMuzzleType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 30);
        return _muzzleType[dnaSection % _muzzleType.length];
    }

    function getEyesType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 32);
        return _eyesType[dnaSection % _eyesType.length];
    }

    function getBrowsType(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 34);
        return _browsType[dnaSection % _browsType.length];
    }

    function getIsRound(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 36);
        return _isRound[dnaSection % _isRound.length];
    }

    function getIsBlackout(uint256 _dna)
        public
        view
        returns (string memory)
    {
        uint256 dnaSection = _getDNASection(_dna, 2, 38);
        return _isBlackout[dnaSection % _isBlackout.length];
    }
}
