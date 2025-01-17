fmt:
	nix fmt

home: home-manager/home.nix fmt
	home-manager switch --flake .#bibanez@nixos

system: nixos/configuration.nix fmt
	sudo nixos-rebuild switch --flake .#nixos

update:
	nix flake update

optimise:
	nix-store --optimise

all: update home system optimise