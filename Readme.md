# Admin token bank (Sepolia)

## Address
```
MyERC20Token：0xFadcc47E79575f09b6F7ED3936A2A3Eeb86d6E7D sepolia上面的
Deployed by：0x059dC4EEe9328A9f163a7e813B2f5B4A52ADD4dF
admin address: 0x260ef6029160BB9E89A50e0ead94DBf3F4725106
```

## Deploy
```
forge script script/Deploy.s.sol:DeployAdminTokenBankScript --rpc-url sepolia --broadcast --verify -vvvv
```

## Interaction
```
forge script script/Interaction.s.sol:InteractionScript --rpc-url sepolia --broadcast -vvvv
```
