// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Roles is ERC721, EIP712, ERC721Votes, AccessControl {
    
  uint40 public _tokenId;
    
  bool governorSet;

  struct Person {

    uint40 id;

    bytes32 role;

    bool canGovern;

  }  

  bytes32 public constant GOVERNOR = keccak256("GOVERNOR");

  mapping(address => Person) public persons;

  constructor() ERC721("ROLES", "ROLES") EIP712("ROLES", "1")  {
        
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
      
  }

  function grantGovernRole (bytes32 _role, address _account) public {
    
    require (hasRole(GOVERNOR, msg.sender), "only governor can create governance roles");

    _grantRole(_role, _account);
    
    persons[_account].canGovern = true;
    
  }

  function setGovernor (address _addressGovernor) public {

    require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Must have admin role");
    
    _grantRole(GOVERNOR, _addressGovernor);

    _setRoleAdmin(DEFAULT_ADMIN_ROLE, GOVERNOR);


  }

  function _grantRole(bytes32 role, address account) internal override {

      require (!hasRole(role, account), "No Duplicate role");

      if (role == GOVERNOR) {

          require(governorSet == false, "governor is already set");

          governorSet = true;

      }

      Person storage person =  persons[account];

      person.role = role;

      person.id = _tokenId;

      _mint(account, _tokenId);

      _tokenId++;

      super._grantRole(role, account);
      
    }

    function _revokeRole(bytes32 role, address account) internal override {

      Person memory person =  persons[account];
            
      _burn(info.id);

      person.canGovern = false;
      
      super._revokeRole(role, account);

    }
    

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
       
    ) internal virtual override  {


      Person memory sender =  persons[from];
 
      if (from != address (0)){
          
        revokeRole(sender.role, from);
        
        grantRole(sender.role, to);
   
        super._beforeTokenTransfer(from, to, tokenId, batchSize);

      } else {

        super._beforeTokenTransfer(from, to, tokenId, batchSize);

      }
      
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Votes)
    {
        super._afterTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControl, ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    
}