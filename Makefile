fmt:
	nix fmt

home: home-manager/home.nix fmt
	home-manager switch --flake .#bibanez@nixos

system: nixos/configuration.nix fmt
	sudo nixos-rebuild switch --flake .#nixos