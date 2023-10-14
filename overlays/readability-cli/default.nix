{ channels, ... }:

final: prev:

{
  inherit (channels.unstable) readability-cli;
}
