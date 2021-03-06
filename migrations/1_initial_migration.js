const Registry = artifacts.require("Registry");
const FeeProvider = artifacts.require("FeeProvider");

module.exports = async function (deployer) {

  await deployer.deploy(FeeProvider, [0, 0, 0, 0], 1);
  let feeProvider = await FeeProvider.deployed()

  await deployer.deploy(Registry, "https://chainid-metadata.herokuapp.com/one/", feeProvider.address);
  let registry = await Registry.deployed();

  await registry.registerIdentity("0x707261736164");
};