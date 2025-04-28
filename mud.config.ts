import { defineWorld } from "@latticexyz/world";

export default defineWorld({
  namespace: "mytokenns",
  codegen: {
    generateSystemLibraries: true,
  },
  tables: {
    Owner: {
      schema: {
        owner: "address",
      },
      key: [],
    },
    TotalSupply: {
      schema: {
        totalSupply: "uint256",
      },
      key: [],
    },
    Balances: {
      schema: {
        account: "address",
        value: "uint256",
      },
      key: ["account"],
    },
    Allowances: {
      schema: {
        account: "address",
        spender: "address",
        value: "uint256",
      },
      key: ["account", "spender"],
    },
  },
});
