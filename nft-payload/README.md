# Moonlight NFT with payload

### Project setup

    nvm use 16.15.0
    yarn create next-app
    yarn add --dev hardhat

### Compile, deploy and verify contracts

    yarn hardhat compile
    yarn hardhat run --network matic scripts/deploy.js
    yarn hardhat verify --network matic "new-contract-address"