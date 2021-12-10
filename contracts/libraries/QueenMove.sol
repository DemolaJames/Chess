//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Move.sol";

contract QueenMove is Move {

    struct HorizontalorVerticalMoveVariables {

        uint positionX;
        uint positionY;

        uint up;
        uint down;
        uint right;
        uint left;

        int newX;
        int newY;
        uint movesChecker;
        int boardSize;

    }


    function validMovesFor(SystemTypes.Position memory _position, uint _boardSize) public view returns (SystemTypes.Position[] memory) {
       

        SystemTypes.Position[] memory diagonalPossibles = super.validDiagonalMoves(_position, _boardSize);
        SystemTypes.Position[] memory horizontalandVerticalPossibles = validHorizontalandVerticalMoves(_position, _boardSize);

        uint totalPossibleMovesCount = diagonalPossibles.length + horizontalandVerticalPossibles.length;
        //console.log("Total possible moves: %d",totalPossibleMovesCount); 
        
        SystemTypes.Position[] memory totalPossibleMoves = new SystemTypes.Position[](totalPossibleMovesCount);

        uint i=0;
        uint j=0;
        uint k = 0;
        
        // merge both diagonal and cross moves into one array
        while ( (i < diagonalPossibles.length || j < horizontalandVerticalPossibles.length) && (k < totalPossibleMovesCount) ) {
                
                if(i < diagonalPossibles.length)
                        totalPossibleMoves[k] = diagonalPossibles[i];

                if(j < horizontalandVerticalPossibles.length)
                {
                        k = (i < diagonalPossibles.length) ? k +1 : k;
                        totalPossibleMoves[k] = horizontalandVerticalPossibles[j];
                }

                i++; j++; k++;
        }


        return totalPossibleMoves;
    }


    function validHorizontalandVerticalMoves(SystemTypes.Position memory _position, uint _boardSize) private view returns (SystemTypes.Position[] memory) {
      
        HorizontalorVerticalMoveVariables memory hv;

       
        hv.positionX = uint(_position.X); // row 
        hv.positionY = uint(_position.Y); // column

       
        uint uBoardSize = _boardSize;

        // Use an algorithm to get total possible horizontal and vertical moves on board
        hv.up = uBoardSize - hv.positionX;
        hv.down = hv.positionX - 1;
        hv.right = uBoardSize - hv.positionY;
        hv.left = hv.positionY - 1;

        uint totalPosibbleOptions = hv.up + hv.down + hv.right + hv.left;
        // console.log("Total horizontal and vertical possible moves: %d",totalPosibbleOptions); 
               

        // store variable for the possible moves
        SystemTypes.Position[] memory possibleMoves = new SystemTypes.Position[](totalPosibbleOptions);
      

        hv.newX = int(hv.positionX); // row 
        hv.newY = int(hv.positionY); // column
        hv.movesChecker = 0 ;
        hv.boardSize = int(uBoardSize);


       // all possible moves in the UP direction (1,0)
        int iUp = hv.newX + 1;
        while (iUp  <= hv.boardSize) {
                console.log("%d:  A possible move in the UP position is (%d,%d)",hv.movesChecker, uint(iUp), uint(hv.newY)); 
                possibleMoves[hv.movesChecker] = SystemTypes.Position(uint(iUp), uint(hv.newY));
                hv.movesChecker++;
                iUp++;
        }

        // all possible moves in the DOWN direction (-1, 0)
        int iDwn = hv.newX - 1;
        while(iDwn > 0){
                console.log("%d:  A possible move in the DOWN position is (%d,%d)",hv.movesChecker, uint(iDwn), uint(hv.newY)); 
                possibleMoves[hv.movesChecker] = SystemTypes.Position(uint(iDwn), uint(hv.newY));
                hv.movesChecker++;
                iDwn--;
        }
      
        // all possible moves in the RIGHT direction (0, 1)
        int jRgt= hv.newY + 1;
        while (jRgt <= hv.boardSize) {
                console.log("%d:  A possible move to the RIGHT position is (%d,%d)",hv.movesChecker, uint(hv.newX), uint(jRgt)); 
                possibleMoves[hv.movesChecker] = SystemTypes.Position(uint(hv.newX), uint(jRgt));
                hv.movesChecker++;
                jRgt++;
        }

        // all possible moves in the LEFT direction (0, -1)
        int jDN = hv.newY - 1;
        while (jDN > 0) {
                console.log("%d:  A possible move to the LEFT position is (%d,%d)",hv.movesChecker, uint(hv.newX), uint(jDN)); 
                possibleMoves[hv.movesChecker] = SystemTypes.Position(uint(hv.newX), uint(jDN));
                hv.movesChecker++;
                jDN--;
        } 

        return possibleMoves;

    }

}