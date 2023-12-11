const ReceiveUSDC = artifacts.require("ReceiveUSDC");

module.exports = function (deployer) {
  deployer.deploy(ReceiveUSDC, "0x07865c6E87B9F70255377e024ace6630C1Eaa37F");
};