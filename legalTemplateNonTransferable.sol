// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable@4.7.3/security/PausableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable@4.7.3/access/AccessControlUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable@4.7.3/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable@4.7.3/proxy/utils/UUPSUpgradeable.sol";


contract legalTemplate is Initializable, PausableUpgradeable, UUPSUpgradeable, AccessControlUpgradeable {

  bytes32 public agreementHash;
  
  bytes32 public constant PAUSER = keccak256("PAUSER");
  
  event agreementHashSetted(bytes32 indexed _hash);
  

  constructor() {
    
      _disableInitializers();
    
    }

  function initialize () initializer public {
    
      __Pausable_init();
      __UUPSUpgradeable_init();
      _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

    }

  function pause() public onlyRole(PAUSER)  {
        _pause();
    }

  function unpause() public onlyRole(PAUSER) {
        _unpause();
    }

  function _authorizeUpgrade(address newImplementation)
        internal
        whenPaused
        onlyRole(DEFAULT_ADMIN_ROLE)
        override 
    {}
  

  // récupère l'adresse de stockage du hash du contrat
  function setAgreementHash (bytes32  _agreementHash) public onlyRole(DEFAULT_ADMIN_ROLE) {

    // ne pas oublier de mettre le '0x' devant le sha256
    agreementHash = _agreementHash;
    
    emit agreementHashSetted (agreementHash);
    
  }


  function terminateContract (address payable _recipient) public whenPaused onlyRole(DEFAULT_ADMIN_ROLE) 
{
    selfdestruct(_recipient);
    
  }


}

