@PHONY: build
build:
	@forge build

@PHONY: tests
tests:
	@forge test -vv

@PHONY: tests-gas
tests-gas:
	@forge test -vv --gas-report

@PHONY: deploy-local
deploy-local:
	@forge script script/BoutiqueNFT.s.sol:BoutiqueNFTDeploy --fork-url http://localhost:8545 --broadcast
