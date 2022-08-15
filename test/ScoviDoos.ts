import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('Scovi Doos contract', () => {
  const setup = async ({ maxSupply = 10000 }) => {
    const [owner] = await ethers.getSigners();
    const ScoviDoos = await ethers.getContractFactory('ScoviDoos');
    const deployed = await ScoviDoos.deploy(maxSupply);

    return { owner, deployed };
  };

  describe('Deployment', () => {
    it('Set max supply to passed param', async () => {
      const maxSupply = 4000;
      const { deployed } = await setup({ maxSupply });
      const returnedMaxSupply = await deployed.maxSupply();

      expect(returnedMaxSupply).to.equal(maxSupply);
    });
  });

  describe('Minting', () => {
    it('Mints a new token and assigns it to owner', async () => {
      const { owner, deployed } = await setup({});
      const ownerAddress = await owner.getAddress();
      await deployed.mint();
      const ownerOfMinted = await deployed.ownerOf(0);

      expect(ownerOfMinted).to.equal(ownerAddress);
    });

    it('Has a minting limit', async () => {
      const maxSupply = 2;
      const { deployed } = await setup({ maxSupply });

      // Mint all
      for (let index = 0; index < Array(maxSupply).length; index++) {
        await deployed.mint();
      }

      // Assert the last minting
      await expect(deployed.mint()).to.be.revertedWith('No ScoviDoos left');
    });
  });

  describe('TokenURI', () => {
    it('Returns valid metadata', async () => {
      const { deployed } = await setup({});
      await deployed.mint();
      const tokenURI = await deployed.tokenURI(0);
      const stringifiedTokenURI = tokenURI.toString();
      const [, base64JSON] = stringifiedTokenURI.split('data:application/json;base64,');
      const stringifiedMetadata = Buffer.from(base64JSON, 'base64').toString('ascii');
      const metadata = JSON.parse(stringifiedMetadata);

      expect(metadata).to.have.all.keys('name', 'description', 'image', 'attributes');
    });
  });
});
