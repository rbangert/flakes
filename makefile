############################################################################
#
#  Nix commands related to the local machine
#
############################################################################
local:
	sudo nixos-rebuild switch --flake .#${HOST}

# local-up:
# 	sudo nixos-rebuild switch --flake .#${HOST} --upgrade

# local-debug:
# 	nixos-rebuild switch --flake .#${HOST} --use-remote-sudo --show-trace --verbose

# update:
# 	nix flake update

# history:
# 	nix profile history --profile /nix/var/nix/profiles/system

# gc:
# 	# remove all generations older than 7 days
# 	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# 	# garbage collect all unused nix store entries
# 	sudo nix store gc --debug

# ############################################################################
# #
# #  Remote distributed building
# #
# ############################################################################

# dia:
# 	deploy --remote-build .#dia
