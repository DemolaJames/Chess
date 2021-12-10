import { ethers } from "hardhat";
import { LibraryMappingsToContract } from ".././deployhelper";

async function main() {
   //todo: fill in the deployment code here to deploy ComplexGame, SimpleGame,
   //Please consider upgradability and access control if possible, could change the Corresponding Contract if needed

  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);

  const balance = await deployer.getBalance();
  console.log(`Account balance before deployments: ${balance.toString()}`);
  console.log("");
  let libraryAddressStore= new Map();

  for (const item in LibraryMappingsToContract) {

    let contractNameKey = item;
    let libraryArray = LibraryMappingsToContract[item];
    let libraryObject = {};

    for(let i =0; i < libraryArray.length; i++){
   
   
        let libraryName = libraryArray[i];

         // Check if library has been deployed with another contract
         if(!libraryAddressStore.has(libraryName)){
              // Deploy lib
              const lib = await ethers.getContractFactory(libraryName);
              const libInfo = await lib.deploy();

              // Store address for possible use later by another contract
              libraryAddressStore.set(libraryName, libInfo.address);

              console.log(`${libraryName} Library Address Is: ${libInfo.address}`);
         }
     
        // Add to local library object for linking when deploying contract
        libraryObject[libraryName] = libraryAddressStore.get(libraryName);


    }


    // Deploy Contract Section

    // Check if contract has linking libraries 
    if(libraryArray.length == 0){ 

          // contract has no linked library
          const contract = await ethers.getContractFactory(contractNameKey);
          const contractInfo = await contract.deploy();

          console.log(`${contractNameKey} Contract Address Is: ${contractInfo.address}`);

    } else { 
      
          // contract has linking libraries

          const contract = await ethers.getContractFactory(contractNameKey, { libraries : libraryObject});
          const contractInfo = await contract.deploy();

          console.log(`${contractNameKey} Contract Deployment with ${Object.keys(libraryObject).length} library linked and the Address Is: ${contractInfo.address}`);

    }
   

  }

  const balanceAfter = await deployer.getBalance();
  console.log("");
  console.log(`Account balance after deployments: ${balanceAfter.toString()}`);



}
 
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
