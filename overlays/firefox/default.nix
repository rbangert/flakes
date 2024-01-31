{channels, ...}: final: prev: {
  inherit (channels.unstable) firefox-bin firefox-devedition;
}
