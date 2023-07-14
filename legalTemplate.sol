// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable@4.7.3/security/PausableUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable@4.7.3/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts-upgradeable@4.7.3/proxy/utils/UUPSUpgradeable.sol";

import "Iroles.sol";


contract legalTemplate is Initializable, PausableUpgradeable, UUPSUpgradeable {

  bytes32 public agreementHash;
  
  event agreementHashSetted(bytes32 indexed _hash);
  
  IrolesTransferable public rolesToken;

  constructor() {
    
      _disableInitializers();
    
    }

  function initialize (address _rolesTokenAddress) initializer public {
    
      __Pausable_init();
      __UUPSUpgradeable_init();
      rolesToken = IrolesTransferable(_rolesTokenAddress);

    }

  function pause() public  {
        _pause();
    }

  function unpause() public {
        _unpause();
    }

  function _authorizeUpgrade(address newImplementation)
        internal
        override 
    {
      require(rolesToken.hasRole(0x00, msg.sender)); 
    }
  
  // récupère l'adresse de stockage du hash du contrat
  
  function setAgreementHash (bytes32  _agreementHash ) public {
    
    // ne pas oublier de mettre le '0x' devant le sha256
    agreementHash = _agreementHash;
    
    emit agreementHashSetted (agreementHash);
    
  }


}

