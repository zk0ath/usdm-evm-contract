const MyUsdc = artifacts.require("MyUsdc");
const ReceiveUSDC = artifacts.require("ReceiveUSDC");

module.exports = async function (deployer) {

  var tx = await deployer.deploy(MyUsdc, "0xafd7a5b2E91F8b7A0324cC0a5fd18827c476dDB0");
  console.log(tx)
  deployer.deploy(ReceiveUSDC, "0x07865c6E87B9F70255377e024ace6630C1Eaa37F");
};