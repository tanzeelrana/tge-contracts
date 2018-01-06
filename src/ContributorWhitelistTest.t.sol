pragma solidity ^0.4.17;

import "ds-test/test.sol";
import "./base.sol";
import "./tge.sol";


contract Wallet {
  // Wallet contract to accept payment
  function() payable public {}
}


contract ContributorWhitelistTest is DSTest {
    ContributorWhitelist whitelist;

    function setUp() public {
        whitelist = new ContributorWhitelist();
    }

    function test_OnlyOwnerOrCrowdSaleContract() public {
      LendroidSupportToken LST = new LendroidSupportToken();
      Wallet ColdStorageWallet = new Wallet();
      uint256 totalBonus = 6 * (10 ** 9);
      uint256 initialBonusPercentage = 25 * (10 ** 16);
      uint256 saleStartTimestamp = now;
      uint256 saleEndTimestamp = now + 10 days;
      PrivateSale sale = new PrivateSale(
        address(LST),
        24000,
        address(ColdStorageWallet),
        address(whitelist),
        totalBonus,
        initialBonusPercentage,
        saleStartTimestamp,
        saleEndTimestamp
      );
      // Assert owner is current contract
      assertEq(
        whitelist.owner(),
        this
      );
      // link PrivateSale to Whitelist
      whitelist.setAuthority(address(sale));
      assertTrue(
        whitelist.authorized(address(sale))
      );
    }

    function test_whitelistAddress() public {
      assertTrue(
        !whitelist.isWhitelisted(address(this))
      );
      whitelist.whitelistAddress(this);
      assertTrue(
        whitelist.isWhitelisted(address(this))
      );
    }

    function test_blacklistAddress() public {
      assertTrue(
        !whitelist.isWhitelisted(address(this))
      );
      whitelist.whitelistAddress(this);
      assertTrue(
        whitelist.isWhitelisted(address(this))
      );
      whitelist.blacklistAddress(this);
      assertTrue(
        !whitelist.isWhitelisted(address(this))
      );
    }

}
