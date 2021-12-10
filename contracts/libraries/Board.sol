//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import {SystemTypes} from "./SystemTypes.sol";
import "hardhat/console.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";


/*  
 * To help with visualization for understanding this contract and child contracts (base size of 8 if no size is supplied at runtime)
 *             
 *                    X - AXIS
 *               1  2  3  4  5  6  7  8
 *            1  x  x  x  x  x  x  x  x
 *        Y   2  x  x  x  x  x  x  x  x
 *        -   3  x  x  x  x  x  x  x  x
 *        A   4  x  x  x  x  x  x  x  x
 *        X   5  x  x  x  x  x  x  x  x
 *        I   6  x  x  x  x  x  x  x  x
 *        S   7  x  x  x  x  x  x  x  x
 *            8  x  x  x  x  x  x  x  x
 *
 */

contract Board {

    uint public  boardSize;
    enum SupportedPieces { Bishop, Queen }
    uint[2][] public piecesLocationOnBoardArrayStore;

    mapping(uint => bool) public pieceLocationOnBoardMapStore;
   // uint pieceLocationOnBoardMapStoreCount;

   
    constructor(){
        boardSize = 8;
      //  pieceLocationOnBoardMapStoreCount = 0;
    }

    
    function create(uint _preferredSize) public {
        require(_preferredSize != 0, "Not Allowed");
        boardSize = _preferredSize;
    }

    function getBoardSize() public view returns (uint){
        return boardSize;
    }

    // can be refactored into a library
    function checkSupportedPieces(string memory pieceType) external pure returns (bool){
        if (keccak256(bytes(pieceType)) == keccak256("Queen")) return true;
        if (keccak256(bytes(pieceType)) == keccak256("Bishop")) return true;
       return false;
    }

    // can be refactored into a library
    function isPositionValid(SystemTypes.Position memory _position) private view returns (bool){
        
         if(_position.X < 1 || _position.Y < 1 || _position.X > boardSize || _position.Y > boardSize )
         return false;

        return true;
    }

  

    /* 
    *  ------------------------------------------------------
    *                ARRAY STORE : 
    *  ------------------------------------------------------
    */

    function getFilledPostionsArrayStore() public view returns (uint[2][] memory){
        return piecesLocationOnBoardArrayStore;
    }

    function getTakenPositionsOnBoardArrayStore() public view returns (uint){
        return piecesLocationOnBoardArrayStore.length;
    } 


    function isPositionFilledOnBoardArrayStore(SystemTypes.Position memory _position) public view returns (bool){
        
        // check for prior existence
        bool exists = false;
       for(uint i= 0; i < piecesLocationOnBoardArrayStore.length; i++ ){  
            if(piecesLocationOnBoardArrayStore[i][0] == _position.X && piecesLocationOnBoardArrayStore[i][1] == _position.Y){
                exists = true;
                break;
            }
       }
        return exists;
    }


    function setPostionForPieceOnBoardArrayStore(SystemTypes.Position memory _newPosition) public returns (bool){

       require(isPositionValid(_newPosition),"Position Not Allowed on Board");
        bool result = false;

       if(!isPositionFilledOnBoardArrayStore(_newPosition)){
            // set new position on the board
            piecesLocationOnBoardArrayStore.push([_newPosition.X, _newPosition.Y]); 
            result = true;
       }      
        return result;
    }


    function changePostionForPieceOnBoardArrayStore(SystemTypes.Position memory _currentPosition, SystemTypes.Position memory _newPosition) public returns (bool){
      
       require(isPositionValid(_newPosition),"Position Not Allowed on Board");
       bool result = false;


       if(!isPositionFilledOnBoardArrayStore(_newPosition)){

            // set new position on the board
            piecesLocationOnBoardArrayStore.push([_newPosition.X, _newPosition.Y]); 

            // stop tracking previous position
            removePositionOnBoardArrayStore(_currentPosition);
            result = true;
       }      
       
        return result;
    }


    function removePositionOnBoardArrayStore(SystemTypes.Position memory _position) private {
        
       // store current array
       uint[2][] memory tempArray = piecesLocationOnBoardArrayStore;

       // delete data in it 
       delete piecesLocationOnBoardArrayStore;

       // push new items into it
        uint i = 0;
        while(i < tempArray.length){

            if(!(tempArray[i][0] == _position.X && tempArray[i][1] == _position.Y))
                 piecesLocationOnBoardArrayStore.push([tempArray[i][0], tempArray[i][1]]);
            i++;
        }

    } 



}