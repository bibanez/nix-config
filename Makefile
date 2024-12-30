home: home-manager/home.nix
	home-manager switch --flake .#bibanez@nixos

system: nixos/configuration.nix
	sudo nixos-rebuild switch --flake .#nixos