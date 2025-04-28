// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

import { Script } from "forge-std/Script.sol";
import { console } from "forge-std/console.sol";

import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { ResourceId, WorldResourceIdLib } from "@latticexyz/world/src/WorldResourceId.sol";
import { RESOURCE_SYSTEM } from "@latticexyz/world/src/worldResourceTypes.sol";

import { Owner } from "../src/codegen/tables/Owner.sol";

import { MyToken } from "../src/MyToken.sol";
import { IWorld } from "../src/codegen/world/IWorld.sol";

contract PostDeploy is Script {
  function run(address worldAddress) external {
    StoreSwitch.setStoreAddress(worldAddress);
    IWorld world = IWorld(worldAddress);
    require(isContract(worldAddress), "Invalid world address provided");

    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    bytes14 namespace = "mytokenns";
    bytes16 name = "MyToken";

    ResourceId systemId = WorldResourceIdLib.encode(RESOURCE_SYSTEM, namespace, name);

    vm.startBroadcast(deployerPrivateKey);

    MyToken myToken = new MyToken(world);
    world.registerSystem(systemId, myToken, true);
    Owner.set(vm.addr(deployerPrivateKey));

    vm.stopBroadcast();

    console.log("Deployed MyToken at:", address(myToken));
  }

  function isContract(address addr) internal view returns (bool) {
    uint256 size;
    assembly {
      size := extcodesize(addr)
    }
    return size > 0;
  }
}
