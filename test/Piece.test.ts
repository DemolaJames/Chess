import { ethers } from "hardhat";
import { assert, expect } from "chai";
import { Contract } from "@ethersproject/contracts";  
import { QUEEN_PIECE, ROOK_PIECE, BISHOP_PIECE } from './../helpers';



describe("PieceDeployed", function () { 
    let piece: Contract;
    
    before(async function () {
       
        const Piece = await ethers.getContractFactory("Piece");
        piece = await Piece.deploy(QUEEN_PIECE); 
      });

    describe("PieceValidation", () => {

        describe("Success", () => {

            it("Queen Piece is allowed on Board",  async () => {
                var result = await piece.checkSupportedPieces(QUEEN_PIECE);
                assert.equal(result, true); 
            });

            it("Bishop Piece is allowed on Board",  async () => {
                var result = await piece.checkSupportedPieces(BISHOP_PIECE);
                assert.equal(result, true); 
            });

        });

        describe("Fail", () => {

            it("Should reject Rook on Board",  async () => {
                let result = await piece.checkSupportedPieces(ROOK_PIECE);
                assert.equal(result, false); 
            });

        });
    });
  
  
  
  });
  