# HTLC: Hashed Time Lock Contract 

To learn about HTLC read [this article](https://corporatefinanceinstitute.com/resources/knowledge/other/hashed-timelock-contract-htlc/#:~:text=Summary-,A%20Hashed%20Timelock%20Contract%20(HTLC)%20is%20a%20transactional%20agreement%20used,time%20or%20a%20preset%20deadline.).


```
> htlc@1.0.0 test /home/saurav/projects/hashed-timelock-contract-ethereum
> hardhat test

Creating Typechain artifacts in directory typechain for target ethers-v5
Successfully generated Typechain artifacts!


  Hash Time Locked Contracts
    Contracts
      ✓ Should not be address(0)
      ✓ Should match total supply
    New HTLC
      ✓ Should approve amount
      ✓ Should create new contract (71ms)
    Withdraw
      ✓ Should be able withdraw with right conditions (44ms)

```

### EIP-712 and EIP-191

This contract follows [EIP-712](https://eips.ethereum.org/EIPS/eip-712) and [EIP-191](https://eips.ethereum.org/EIPS/eip-191) standards

### Pre Requisites

Before running any command, make sure to install dependencies:

```sh
$ npm i
```

### Compile

Compile the smart contracts with Hardhat:

```sh
$ npm run compile
```

### TypeChain

Compile the smart contracts and generate TypeChain artifacts:

```sh
$ npm run typechain
```

### Lint Solidity

Lint the Solidity code:

```sh
$ npm run lint:sol
```

### Lint TypeScript

Lint the TypeScript code:

```sh
$ npm run lint:ts
```

### Test

Run the Chai tests:

```sh
$ npm run test
```

### Coverage

Generate the code coverage report:

```sh
$ npm run coverage
```

### Report Gas

See the gas usage per unit test and average gas per method call:

```sh
$ REPORT_GAS=true npm run test
```

### Clean

Delete the smart contract artifacts, the coverage reports and the Hardhat cache:

```sh
$ npm run clean
```

### Deploy

Deploy the contracts to Hardhat Network:

```sh
$ npm run deploy
```

Deploy the contracts to a specific network, such as the Ropsten testnet:

```sh
$ npm run deploy:network ropsten
```

## Syntax Highlighting

If you use VSCode, you can enjoy syntax highlighting for your Solidity code via the
[vscode-solidity](https://github.com/juanfranblanco/vscode-solidity) extension. The recommended approach to set the
compiler version is to add the following fields to your VSCode user settings:

```json
{
  "solidity.compileUsingRemoteVersion": "v0.8.3+commit.8d00100c",
  "solidity.defaultCompiler": "remote"
}
```

Where of course `v0.8.3+commit.8d00100c` can be replaced with any other version.
