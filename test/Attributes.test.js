
/**
 * 
 * autogenerated by solidity-visual-auditor
 * 
 * execute with: 
 *  #> truffle test <path/to/this/test.js>
 * 
 * */
 const { expect } = require("chai");
 const { ethers, waffle} = require("hardhat");
 const provider = waffle.provider;

    describe("Attribute", function () {
        let Attributes, Attributesob, owner,user1,user2, user3, user4, user5;
        before(async () => {
        [owner,user1,user2,user3,user4,user5_] = await ethers.getSigners();
    
   
     
       Attributes = await ethers.getContractFactory("Attributes");
       Attributesob = await Attributes.deploy();
       await Attributesob.deployed({from:owner.address});
       console.log('Attributes',Attributesob.address);
    
        });
  

  
});
