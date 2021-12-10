import { ethers } from "hardhat";
import { assert } from "chai";
import { Contract } from "@ethersproject/contracts";  
import { QUEEN_PIECE } from './../helpers';

describe("QueenMoveDeployed", function () { 
    let queen: Contract;
    before(async function () {
       
      const result = await ethers.getContractFactory("QueenMove" );
      queen = await result.deploy(); 
    });


    describe("QueenProperties", () => {

        describe("Success", () => {


            // it("Can move Diagonally on the board",  async () => {
            //     var pos =  { X:3, Y:3};
            //     var moves = await queen.checkSupportedPieces();
            //     assert.equal(result, QUEEN_PIECE);

            // });

        });
    });


});