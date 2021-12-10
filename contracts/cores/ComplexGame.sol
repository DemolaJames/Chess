//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "../interfaces/IGame.sol";
import "../libraries/Piece.sol";
import "../libraries/SystemTypes.sol";
import "../libraries/Randomizer.sol";
import "hardhat/console.sol";
contract ComplexGame is IGame {

    mapping (uint => SystemTypes.Position) private pieceStartingPoisitionMap;
    string[] private pieces = new string[](2);
    

    function play(uint256 _moves) override external { 

        playRandom(_moves);
      //  this.demoQueenMoves(_moves);
      //  this.demoBishopMoves(_moves);

    }

    
    function setup() override external {
        // todo: Put your code here.

        pieces[0]= "Queen";
        pieces[1] = "Bishop";
       // pieces[2] = "Knight";
         
        pieceStartingPoisitionMap[0] = SystemTypes.Position(3,4);
        pieceStartingPoisitionMap[1] = SystemTypes.Position(7,2);
       // pieceStartingPoisitionMap[2] = SystemTypes.Position(4,4);

        

    }


    function demoQueenMoves(uint256 _moves)  external{

        SystemTypes.Position memory  staticPiece1PositionOnboard = SystemTypes.Position(3,1);
        SystemTypes.Position memory  staticPiece2PositionOnboard  = SystemTypes.Position(7,4); 
        SystemTypes.Position memory movingPieceCurrentPosition  = SystemTypes.Position(8,4); 

        Piece piece = new Piece("Queen");
        string memory queenPieceName = piece.getPieceType();

        
        console.log(" ");
        console.log("%s: Initial Position before moving is (%d,%d)", queenPieceName, movingPieceCurrentPosition.X, movingPieceCurrentPosition.Y);
        console.log(" ");

        // place 1 non-moving queen on the board
        piece.setPostionForPieceOnBoardArrayStore(staticPiece1PositionOnboard);
        piece.setPostionForPieceOnBoardArrayStore(staticPiece2PositionOnboard);

        for (uint i = 0; i < _moves; i++) {

            (SystemTypes.Position[] memory possibles, uint originalPossibleMoves,  uint takenPositionsInPossibleMoves, uint takenPositionsOnBoard) = piece.generateMoves(movingPieceCurrentPosition);
            
            console.log(" ");
            console.log("Current taken Positions on the Board: %d", takenPositionsOnBoard);
            console.log("Possible moves: %d  - Taken Positions occurring in possible moves: %d  - Refined Possible moves: %d ", originalPossibleMoves, takenPositionsInPossibleMoves, possibles.length);
            
        
            uint r = Randomizer.random(possibles.length) % possibles.length; 
            SystemTypes.Position memory movingPieceCurrentPositionHolder =  movingPieceCurrentPosition;
            movingPieceCurrentPosition = possibles[r]; 
            console.log("--------------------------------- ");
            console.log("%s: New Position is (%d,%d)", queenPieceName, movingPieceCurrentPosition.X, movingPieceCurrentPosition.Y); 
            console.log("--------------------------------- ");
            console.log(" ");

            // change position on board
            piece.changePostionForPieceOnBoardArrayStore(movingPieceCurrentPositionHolder, movingPieceCurrentPosition);

        }
    }


    function demoBishopMoves(uint256 _moves)  external{


        SystemTypes.Position memory  staticBishop1PositionOnboard = SystemTypes.Position(1,1);
        SystemTypes.Position memory  staticBishop2PositionOnboard  = SystemTypes.Position(4,4); 

        SystemTypes.Position memory movingPieceCurrentPosition = SystemTypes.Position(6,6); 

        Piece piece = new Piece("Bishop");
        string memory pieceName = piece.getPieceType();

        
        console.log(" ");
        console.log("%s: Initial Position before moving is (%d,%d)", pieceName, movingPieceCurrentPosition.X, movingPieceCurrentPosition.Y);
        console.log(" ");

        // place  non-moving bishops on the board
        piece.setPostionForPieceOnBoardArrayStore(staticBishop1PositionOnboard);
        piece.setPostionForPieceOnBoardArrayStore(staticBishop2PositionOnboard);

        for (uint i = 0; i < _moves; i++) {

            (SystemTypes.Position[] memory possibles, uint originalPossibleMoves, uint takenPositionsInPossibleMoves, uint takenPositionsOnBoard) = piece.generateMoves(movingPieceCurrentPosition);
            
            console.log(" ");
            console.log("Current taken Positions on the Board: %d", takenPositionsOnBoard);
            console.log("Possible moves: %d  - Taken Positions occurring in possible moves: %d  - Refined Possible moves: %d ", originalPossibleMoves, takenPositionsInPossibleMoves, possibles.length);
            
        
            uint r = Randomizer.random(possibles.length) % possibles.length; 
            SystemTypes.Position memory movingPieceCurrentPositionHolder =  movingPieceCurrentPosition;
            movingPieceCurrentPosition = possibles[r]; 
            console.log("--------------------------------- ");
            console.log("%s: New Position is (%d,%d)", pieceName, movingPieceCurrentPosition.X, movingPieceCurrentPosition.Y); 
            console.log("--------------------------------- ");
            console.log(" ");

            // change position on board
            piece.changePostionForPieceOnBoardArrayStore(movingPieceCurrentPositionHolder, movingPieceCurrentPosition);

        }
    }

    function playRandom(uint _moves) private{

        Piece piece = new Piece("Queen");
        piece.create(10);

        console.log("------ GAME RUNNER ------- ");
        for (uint i = 0; i < _moves; i++) {

                // pick random piece for each iteration
                uint ranH = (i == 0) ? 2 : (i *3);
                uint r = Randomizer.random(pieces.length * ranH) % (pieces.length * ranH);
                r = (r %2 == 1 ) ? 0 : 1;

                string memory selectedPiece = pieces[r]; 

               

                console.log(" ");
                console.log("%s: Initial Position before moving is (%d,%d)", selectedPiece, pieceStartingPoisitionMap[r].X, pieceStartingPoisitionMap[r].Y);
                console.log(" ");


                piece.setPostionForPieceOnBoardArrayStore(pieceStartingPoisitionMap[r]);
            

                (SystemTypes.Position[] memory possibles, uint originalPossibleMoves,  uint takenPositionsInPossibleMoves, uint takenPositionsOnBoard) = piece.generateMoves(pieceStartingPoisitionMap[r]);
                

                console.log(" ");
                console.log("Current taken Positions on the Board: %d", takenPositionsOnBoard);
                console.log("Possible moves: %d  - Taken Positions occurring in possible moves: %d  - Refined Possible moves: %d ", originalPossibleMoves, takenPositionsInPossibleMoves, possibles.length);
                



                uint r2 = Randomizer.random(possibles.length) % possibles.length; 
                SystemTypes.Position memory movingPieceCurrentPosition =  possibles[r2];

                console.log("--------------------------------- ");
                console.log("%s: New Position is (%d,%d)", selectedPiece, movingPieceCurrentPosition.X, movingPieceCurrentPosition.Y); 
                console.log("--------------------------------- ");
                console.log(" ");
            

                // change position on board
               piece.changePostionForPieceOnBoardArrayStore(pieceStartingPoisitionMap[r], movingPieceCurrentPosition);
           
            



        }

    }

   




} 