//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Move.sol";

contract BishopMove is Move {

    
   
    function validMovesFor(SystemTypes.Position memory _position, uint _boardSize) public view returns (SystemTypes.Position[] memory) {
        return validDiagonalMoves(_position, _boardSize);
    }

   
}