import { ethers } from "hardhat";
import { assert, expect } from "chai";
import { Contract } from "@ethersproject/contracts";  
import { DEFAULT_BOARD_SIZE, EVM_REVERT, EVM_REVERT_POSITION } from './../helpers';

require('chai') 
    .use(require('chai-as-promised'))
    .should()

describe("BoardDeployed", function () { 
    let board: Contract;
    before(async function () {
       
      const result = await ethers.getContractFactory("Board" );
      board = await result.deploy(); 
    });

    describe("CreatingBoard", () => {

        describe("Success", () => {

            it("Creates a default 8 X 8 Board",  async () => {
                var result = await board.getBoardSize();
                assert.equal(result, DEFAULT_BOARD_SIZE);
            });

            let newSize = 9;
            it("Overides default 8 X 8 Board to a " + newSize + " X " + newSize + " Board",  async () => {
                await board.create(newSize);
                var result = await board.getBoardSize();
                assert.equal(result, newSize); 
            });

        });

        describe("Fail", () => {

            it("Should fail on empty board size",  async () => {
                let newSize = 0;
                await board.create(newSize).should.be.rejectedWith(EVM_REVERT);
            });

        });
    });


    describe("BoardState", () => {

        describe("Success", () => {

            it("Board squares should be empty",  async () => {
                var result = await board.getFilledPostionsArrayStore();
                assert.equal(result.length, 0); 
            });

            it("Should return right count of filled positions on the Board: Array Store",  async () => {
                await board.setPostionForPieceOnBoardArrayStore({ X:1, Y:2});
                var filledPositions = await board.getFilledPostionsArrayStore();
                assert.equal(filledPositions.length, 1);
            });

        });

        describe("Fail", () => {

            it("Should prevent position from being filled when it has an occupant already on the Board: Array Store",  async () => {
                await board.setPostionForPieceOnBoardArrayStore({ X:1, Y:2});
                var filledPositions = await board.getFilledPostionsArrayStore();
                assert.equal(filledPositions.length, 1);

            });

            it("Should prevent illegal positions the Board",  async () => {
                await board.setPostionForPieceOnBoardArrayStore({ X:0, Y:2}).should.be.rejectedWith(EVM_REVERT_POSITION); 
            });

            it("Should prevent positions greater than Board size",  async () => {
                await board.setPostionForPieceOnBoardArrayStore({ X:100, Y:2}).should.be.rejectedWith(EVM_REVERT_POSITION); 
            });

            it("Should Prevent duplicates in position store: Array Store",  async () => {
                await board.setPostionForPieceOnBoardArrayStore({ X:3, Y:9});
                var result = await board.isPositionFilledOnBoardArrayStore({ X:3, Y:9});
                assert.equal(result, true);
            });

            // it("Should prevent duplicates in position store: Map Store",  async () => {
            //     await board.setPostionForPieceMapStore({ X:1, Y:2});
            //     var result = await board.isPositionFilledOnBoardMapStore({ X:1, Y:2});
            //     assert.equal(result, true);
            // });



        });
    });


});
