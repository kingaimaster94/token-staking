# token-staking
This is Fungible token staking.

**[Symbiotic Protocol](https://symbiotic.fi) is an extremely flexible and permissionless shared security system.**

This repository contains a Symbiotic Collateral interface and its default implementation.

## Collateral

**Collateral** - a concept introduced by Symbiotic that brings capital efficiency and scale by enabling assets used to secure Symbiotic networks to be held outside of the Symbiotic protocol itself - e.g. in DeFi positions on networks other than Ethereum itself.

Symbiotic achieves this by separating the ability to slash assets from the underlying asset itself, similar to how liquid staking tokens create tokenized representations of underlying staked positions. Technically, collateral positions in Symbiotic are ERC-20 tokens with extended functionality to handle penalties.

The Collateral interface can be found [here](./src/interfaces/ICollateral.sol).

## Default Collateral

Default Collateral is a simple version of Collateral that has an instant debt repayment, which supports only non-rebase underlying assets.

The implementation can be found [here](./src/contracts/defaultCollateral).

## Technical Documentation

Technical documentation can be found [here](./specs).

## Security

Security audits can be found [here](./audits).

## Usage

### Env

Create `.env` file using a template:

```
ETH_RPC_URL=
ETHERSCAN_API_KEY=
```

\* ETHERSCAN_API_KEY is optional.

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Format

```shell
forge fmt
```

### Gas Snapshots

```shell
forge snapshot
```

### Deploy
forge script script/deploy/deploy-bsc_testnet.sol:StrUpstaking --broadcast --rpc-url=wss://bsc-testnet-rpc.publicnode.com --private-key

### verify
forge verify-contract --compiler-version 0.8.25+commit.b61c2a91 --chain-id 97 --optimizer-runs 200 0x804C5a95C41Ea87ddA637fBB621D469eaC439e86 src/STR8Token.sol:STR8Token --etherscan-api-key MIQ2B1NB9WNVIN16P6EVC687UJDV65X78K

forge verify-contract --compiler-version 0.8.25+commit.b61c2a91 --chain-id 97 --optimizer-runs 200 0x7E793bA58D4f6c61D62191Ce943f5c79700B89b3 src/StrUpPool.sol:StrUpPool --etherscan-api-key MIQ2B1NB9WNVIN16P6EVC687UJDV65X78K

forge verify-contract --compiler-version 0.8.25+commit.b61c2a91 --chain-id 97 --optimizer-runs 200 0xF367603efADf46920cD93FcaDe1f8517F90b479F src/StrUpStaking.sol:StrUpStaking --etherscan-api-key MIQ2B1NB9WNVIN16P6EVC687UJDV65X78K


str8Token: 0x804C5a95C41Ea87ddA637fBB621D469eaC439e86
  strUpPool: 0x7E793bA58D4f6c61D62191Ce943f5c79700B89b3
  strUpStaking: 0xF367603efADf46920cD93FcaDe1f8517F90b479F