import { ContractInterface, ethers as ethersCore } from 'ethers';
import { ethers } from "hardhat";
import storyDataSourceABI from './poolInfo/abi/storyprotocol/story_data_source.json';

async function main() {
    const storyDataSourceContractAddress = '0xbEf2D967690A1e354c15E49C1841Ea2C09150E22' // the contract address in goerli testnet
    const signerWallet = '0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX' // replace with your own wallet address here
    const hardcodedData = 'Story Data'

    const storyDataSourceContract: ethersCore.Contract = new ethersCore.Contract(
        storyDataSourceContractAddress,
        storyDataSourceABI as ContractInterface,
      );
    const contract = storyDataSourceContract.connect(ethers.provider) 
    const signer = await ethers.getSigner(signerWallet)

    console.log('Start listening')
    ethers.provider.on(contract.filters.StoryOracleRequest(), async (log, event) => {
        console.log('log:', log)
        console.log('event:', event)
        try {
            const tx = await contract.populateTransaction.fulfill(log.topics[1], hardcodedData)
            await signer.sendTransaction(tx)
        } catch(e) {
            console.error('failed to send transaction back to the smart contract:', e)
        }
        
    })
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});