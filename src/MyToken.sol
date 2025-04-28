// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IBaseWorld, WorldConsumer } from "@latticexyz/world-consumer/src/experimental/WorldConsumer.sol";
import { System } from "@latticexyz/world/src/System.sol";

import { WorldContextConsumer } from "@latticexyz/world/src/WorldContext.sol";

import { Allowances } from "./codegen/tables/Allowances.sol";
import { Balances } from "./codegen/tables/Balances.sol";
import { Owner } from "./codegen/tables/Owner.sol";
import { TotalSupply } from "./codegen/tables/TotalSupply.sol";

import { BaseERC20 } from "./BaseERC20.sol";

contract MyToken is BaseERC20, WorldConsumer {
  constructor(IBaseWorld world) WorldConsumer(world) { }

  function name() external pure returns (string memory) {
    return "My token";
  }

  function symbol() external pure returns (string memory) {
    return "MT";
  }

  function decimals() external pure returns (uint8) {
    return 18;
  }

  function totalSupply() external view returns (uint256) {
    return TotalSupply.get();
  }

  function balanceOf(address account) external view returns (uint256) {
    return Balances.get(account);
  }

  function allowance(address owner, address spender) external view returns (uint256) {
    return Allowances.get(owner, spender);
  }

  function mint(address account, uint256 value) external {
    require(_msgSender() == Owner.get(), "Not allowed to mint");
    _mint(account, value);
  }

  function transfer(address to, uint256 value) external returns (bool) {
    address owner = _msgSender();
    _transfer(owner, to, value);

    return true;
  }

  function approve(address spender, uint256 value) external returns (bool) {
    address owner = _msgSender();
    _approve(owner, spender, value, true);

    return true;
  }

  function transferFrom(address from, address to, uint256 value) external returns (bool) {
    address spender = _msgSender();
    _spendAllowance(from, spender, value);
    _transfer(from, to, value);

    return true;
  }

  function burn(uint256 value) external {
    _burn(_msgSender(), value);
  }

  function burnFrom(address account, uint256 value) external {
    _spendAllowance(account, _msgSender(), value);
    _burn(account, value);
  }
}
