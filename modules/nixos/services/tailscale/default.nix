{ config, lib, ... }:

with lib;
with lib.rr-sv;
let
  cfg = config.rr-sv.services.tailscale;
in
{
  options.rr-sv.services.tailscale = with types; {
    enable = mkBoolOpt false "Whether or not to enable tailscale";
  };

  config = mkIf cfg.enable {

    services.tailscale.enable = true;

    networking.firewall = {
      # always allow traffic from your Tailscale network
      trustedInterfaces = [ "tailscale0" ];

      # allow the Tailscale UDP port through the firewall
      allowedUDPPorts = [ config.services.tailscale.port ];

      checkReversePath = "loose";
    };

    boot.kernel.sysctl = {
      "net.ipv6.conf.all.forwarding" = "1"; # for tailscale exit node
    };

    # TODO: automatically join tailscale network and handle 90 day key expiration

    # # create a oneshot job to authenticate to Tailscale
    # systemd.services.tailscale-autoconnect = {
    #   description = "Automatic connection to Tailscale";

    #   # make sure tailscale is running before trying to connect to tailscale
    #   after = [ "network-pre.target" "tailscale.service" ];
    #   wants = [ "network-pre.target" "tailscale.service" ];
    #   wantedBy = [ "multi-user.target" ];

    #   # set this service as a oneshot job
    #   serviceConfig.Type = "oneshot";

    #   # have the job run this shell script
    #   script = with pkgs; ''
    #     # wait for tailscaled to settle
    #     sleep 2

    #     # check if we are already authenticated to tailscale
    #     status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
    #     if [ $status = "Running" ]; then # if so, then do nothing
    #       exit 0
    #     fi

    #     # otherwise authenticate with tailscale
    #     ${tailscale}/bin/tailscale up --login-server=https://ts.ghuntley.net -authkey=tskey-examplekeyhere
    #   '';

  }
