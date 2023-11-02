{ channels, ... }: final: prev: {
  inherit (channels.unstable) github-copilot;
}
