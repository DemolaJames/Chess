//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Board.sol";
import "hardhat/console.sol";
import {SystemTypes} from "./SystemTypes.sol";
import "./QueenMove.sol";
import "./BishopMove.sol";
import "./KnightMove.sol";




contract Piece is Board  {

    string  public pieceName;
    uint[] internal filledPositionIndexes;
      


    constructor(string memory _pieceName)  {
        pieceName = _pieceName;
    }

    function getPieceType() external view returns (string memory){
        return pieceName;
    }


    function generateMoves(SystemTypes.Position memory _position) public returns(SystemTypes.Position[] memory, uint, uint, uint){

            //checks if piece is allowed on board
            require(this.checkSupportedPieces(pieceName),"Not Allowed");

            SystemTypes.Position[] memory validMoves;
            SystemTypes.Position[] memory possibleMoves;


           
            if(keccak256(bytes(pieceName))  == keccak256("Queen")){

                QueenMove move = new QueenMove();
                validMoves = move.validMovesFor(_position, boardSize);
                possibleMoves = cleanPossibleMoveOptions(validMoves);
            }
            else if (keccak256(bytes(pieceName))  == keccak256("Bishop"))  {
               
                BishopMove move = new BishopMove();
                validMoves = move.validMovesFor(_position, boardSize);
                possibleMoves = cleanPossibleMoveOptions(validMoves);
            }
            else if (keccak256(bytes(pieceName)) == keccak256("Knight")) {

            //    KnightMove move = new KnightMove();
            //    validMoves = move.validMovesFor(_position, boardSize);
            //    possibleMoves = cleanPossibleMoveOptions(validMoves);
            }  

        return  (possibleMoves,validMoves.length,(validMoves.length - possibleMoves.length), super.getTakenPositionsOnBoardArrayStore());     

    }


   /*
    * This method takes in possible moves for a piece and removes positions already filled on the board
    */
    function cleanPossibleMoveOptions(SystemTypes.Position[] memory validMoves) private returns (SystemTypes.Position[] memory){

        uint totalPossibleMovesCount = 0;

        // ensure reset
        delete filledPositionIndexes;
    
        // scan through and extract indexes for filled positions
        uint i = 0;
        while(i < validMoves.length){
            
           if(isPositionFilledOnBoardArrayStore(validMoves[i])){ 
                filledPositionIndexes.push(i);
            }else {
                totalPossibleMovesCount++;
            }
            i++;
        }

        
         // enter this block if positions filled on the board exist in possible moves
        if(i != totalPossibleMovesCount ){

            SystemTypes.Position[] memory refinedPossibleMoves = new SystemTypes.Position[](totalPossibleMovesCount);

            // loop through filled indexes
            uint k = 0; 
            uint newIndex = 0;
            uint filledIndexCount = filledPositionIndexes.length;
            while(k < totalPossibleMovesCount){
                
                if( (k < filledIndexCount && k ==  filledPositionIndexes[k]) )
                    continue;

                refinedPossibleMoves[newIndex] = SystemTypes.Position(validMoves[k].X, validMoves[k].Y);
                newIndex++;

                k++;
            }

        return refinedPossibleMoves;
        }

    return validMoves;
    }


  

  
}