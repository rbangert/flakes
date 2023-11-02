{ channels, ... }: final: prev: {
  inherit (channels.unstable) gh;
  inherit (channels.unstable) gh-dash;
}
