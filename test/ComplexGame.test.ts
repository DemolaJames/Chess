import { ethers } from "hardhat";
import { assert, expect } from "chai";
import { Contract } from "@ethersproject/contracts";  


describe("ComplexGame", function () { 
  let randomizerLib: Contract; 
  let complexGame: Contract; 
  before(async function () { 
    const Randomizer = await ethers.getContractFactory("Randomizer");
    randomizerLib = await Randomizer.deploy();
 
     const ComplexGame = await ethers.getContractFactory("ComplexGame", {
      libraries: { 
        Randomizer: randomizerLib.address
        }
     });
     complexGame = await ComplexGame.deploy();
  });

  describe("Play", () => {
    it("Play 5 moves", async function () {
      complexGame.setup();
     complexGame.play(5);
    });
  });   
});