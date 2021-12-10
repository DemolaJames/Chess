//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import {SystemTypes} from "./SystemTypes.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import "hardhat/console.sol";



contract Move {


    struct DiagonalMoveVariables {

        uint positionX;
        uint positionY;

        uint downPositive;
        uint upNegative;
        uint downNegative;
        uint upPositive;

        int newX;
        int newY;
        uint movesChecker;
        int boardSize;

    }  


     function validDiagonalMoves(SystemTypes.Position memory _position, uint _boardSize) internal view returns (SystemTypes.Position[] memory) {
       

        DiagonalMoveVariables memory diag;
       
        diag.positionX = uint(_position.X); // row 
        diag.positionY = uint(_position.Y); // column

        uint uBoardSize = _boardSize;

        // Use an algorithm to get total possible moves on board
        diag.downPositive = Math.min(diag.positionX,diag.positionY) - 1;
        diag.upPositive = uBoardSize - Math.max(diag.positionX, (uBoardSize + 1) - diag.positionY);
        diag.downNegative = Math.min(diag.positionX, (uBoardSize + 1) - diag.positionY) - 1;
        diag.upNegative = uBoardSize - Math.max(diag.positionX,diag.positionY);

        uint totalPosibbleOptions = diag.downPositive + diag.upNegative + diag.downNegative + diag.upPositive;
        //console.log("Total diagonal possible moves: %d",totalPosibbleOptions); 
       
        // store variable for the possible moves
        SystemTypes.Position[] memory results = new SystemTypes.Position[](totalPosibbleOptions);
      

        diag.newX = int(diag.positionX); // row 
        diag.newY = int(diag.positionY); // column
        diag.movesChecker = 0 ;
        diag.boardSize = int(uBoardSize);


       // all possible moves in the down positive direction (1,1)
        int iDP = diag.newX + 1;
        int jDP = diag.newY + 1;
        while (jDP  <= diag.boardSize && iDP <= diag.boardSize) {
                 console.log("%d:  A possible Down Positive position is (%d,%d)",diag.movesChecker, uint(iDP), uint(jDP)); 
                results[diag.movesChecker] = SystemTypes.Position(uint(iDP), uint(jDP));
                diag.movesChecker++;
                iDP++;
                jDP++;
        }

        // all possible moves in the up positive diagonal (1, -1)
        int iUP = diag.newX + 1;
        int jUP = diag.newY - 1;
        while(iUP <= diag.boardSize && jUP > 0){
                 console.log("%d:  A possible Up Positive position is (%d,%d)",diag.movesChecker, uint(iUP), uint(jUP)); 
                results[diag.movesChecker] = SystemTypes.Position(uint(iUP), uint(jUP));
                diag.movesChecker++;
                iUP++;
                jUP--;
        }
      
        // all possible moves in the up negative diagonal (-1, -1)
        int iUN = diag.newX - 1;
        int jUN = diag.newY - 1;
        while (iUN > 0 && jUN > 0) {
                console.log("%d:  A possible Up Negative position is (%d,%d)",diag.movesChecker, uint(iUN), uint(jUN)); 
                results[diag.movesChecker] = SystemTypes.Position(uint(iUN), uint(jUN));
                diag.movesChecker++;
                iUN--;
                jUN--;
        }

        // all possible moves in the down negative diagonal (-1, 1)
        int iDN = diag.newX - 1;
        int jDN = diag.newY + 1;
        while (jDN  <= diag.boardSize && iDN > 0) {
                console.log("%d:  A possible Down Negative position is (%d,%d)",diag.movesChecker, uint(iDN), uint(jDN)); 
                results[diag.movesChecker] = SystemTypes.Position(uint(iDN), uint(jDN));
                diag.movesChecker++;
                iDN--;
                jDN++;
        } 

        return results;

    }
    



}