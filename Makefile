ifneq (,$(wildcard .env))
	include .env
	export
endif

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

@PHONY: solc
solc:
	@rm -rf build/
	@git submodule update --init --recursive
	@solc --bin --abi --overwrite --optimize --optimize-runs=200 --include-path lib --base-path . -o build src/BoutiqueNFT.sol
	@solc --bin --abi --overwrite --optimize --optimize-runs=200 --include-path lib --base-path . -o build src/BoutiqueNFTMarketplace.sol

@PHONY: abigen
abigen: solc
	mkdir -p abi/
	@abigen --bin=./build/BoutiqueNFT.bin --abi=./build/BoutiqueNFT.abi --pkg=abi --out=./abi/BoutiqueNFT.go --type BoutiqueNFT
	@abigen --bin=./build/BoutiqueNFTMarketplace.bin --abi=./build/BoutiqueNFTMarketplace.abi --pkg=abi --out=./abi/BoutiqueNFTMarketplace.go --type BoutiqueNFTMarketplace

@PHONY: create-release-archive
create-release-archive:
	@zip release-$(TAG).zip ./abi/*
