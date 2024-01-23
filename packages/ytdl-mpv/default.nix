{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  socat,
  sqlite,
  findutils,
  jq,
  iconv,
  mpv,
  rofi,
  yt-dlp
}:

stdenvNoCC.mkDerivation {
  pname = "ytdl-mpv";
  version = "0.6.0";

fetchFromGitHub = {
  owner = "andros21";
  repo = "ytdl-mpv";
  rev = "f5efabf4fc44ca1ffb2dbd92511e1d720d69a877";
  hash = "sha256-QxV5++R+WysFr+hppg94cCtNAN6b5BLlGRaFWmFN9a8=";
};

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp bin/mpvctl $out/bin
    cp bin/ytdl-mpv $out/bin
    chmod +x $out/bin/*
  '';

  meta = {
    description = "Rofi script to browse and play YouTube contents using yt-dlp and mpv";
    homepage = "https://github.com/andros21/ytdl-mpv";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [rbangert];
    platforms = lib.platforms.unix;
  };
}
