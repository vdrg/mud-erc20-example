// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { IERC20 } from "@openzeppelin/interfaces/IERC20.sol";
import { IERC20Errors } from "@openzeppelin/interfaces/draft-IERC6093.sol";

import { Allowances } from "./codegen/tables/Allowances.sol";
import { Balances } from "./codegen/tables/Balances.sol";
import { TotalSupply } from "./codegen/tables/TotalSupply.sol";

// Adapted from OpenZeppelin Contracts [token/ERC20/ERC20.sol](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/f989fff93168606c726bc5e831ef50dd6e543f45/contracts/token/ERC20/ERC20.sol)
// Note: Currently we only include the internal functions and add the external ones (IERC20) to the concrete implementation.
// This is due to the fact that system libraries only include functions present in the system file.
abstract contract BaseERC20 is IERC20, IERC20Errors {
  function _mint(address account, uint256 value) internal {
    if (account == address(0)) {
      revert ERC20InvalidReceiver(address(0));
    }

    _update(address(0), account, value);
  }

  function _burn(address account, uint256 value) internal {
    if (account == address(0)) {
      revert ERC20InvalidSender(address(0));
    }

    _update(account, address(0), value);
  }

  function _transfer(address from, address to, uint256 value) internal {
    if (from == address(0)) {
      revert ERC20InvalidSender(address(0));
    }
    if (to == address(0)) {
      revert ERC20InvalidReceiver(address(0));
    }
    _update(from, to, value);
  }

  function _update(address from, address to, uint256 value) internal virtual {
    if (from == address(0)) {
      // Overflow check required: The rest of the code assumes that totalSupply never overflows
      TotalSupply.set(TotalSupply.get() + value);
    } else {
      uint256 fromBalance = Balances.get(from);
      if (fromBalance < value) {
        revert ERC20InsufficientBalance(from, fromBalance, value);
      }
      unchecked {
        // Overflow not possible: value <= fromBalance <= totalSupply.
        Balances.set(from, fromBalance - value);
      }
    }

    if (to == address(0)) {
      unchecked {
        // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
        TotalSupply.set(TotalSupply.get() - value);
      }
    } else {
      unchecked {
        // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
        Balances.set(to, Balances.get(to) + value);
      }
    }

    emit Transfer(from, to, value);
  }

  function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
    if (owner == address(0)) {
      revert ERC20InvalidApprover(address(0));
    }
    if (spender == address(0)) {
      revert ERC20InvalidSpender(address(0));
    }

    Allowances.set(owner, spender, value);

    if (emitEvent) {
      emit Approval(owner, spender, value);
    }
  }

  function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
    uint256 currentAllowance = Allowances.get(owner, spender);
    if (currentAllowance != type(uint256).max) {
      if (currentAllowance < value) {
        revert ERC20InsufficientAllowance(spender, currentAllowance, value);
      }
      unchecked {
        _approve(owner, spender, currentAllowance - value, false);
      }
    }
  }
}
