const Bridge = artifacts.require("Bridge");
const MyUsdc = artifacts.require("MyUsdc");

contract("Bridge", accounts => {
    let bridge;
    let usdcMock;
    const owner = accounts[0];
    const user = accounts[1];

    before(async () => {
        usdcMock = await MyUsdc.new();
        bridge = await Bridge.new(usdcMock.address);
    });

    it("should allow users to deposit USDC tokens", async () => {
        await usdcMock.mint(user, web3.utils.toBN("1000000"));

        await usdcMock.approve(bridge.address, "1000", { from: user });

        await bridge.deposit("1000", { from: user });

        const bridgeBalance = await usdcMock.balanceOf(bridge.address);
        assert.equal(bridgeBalance.toString(), "1000", "The bridge should have 1000 USDC tokens");
    });

});
