{ lib, stdenv
, fetchurl
, makeWrapper
, autoPatchelfHook
, dpkg
, glib
, gtk3
, pulseaudio
, alsa-lib
, xdotool
}:

let
  inherit (stdenv.hostPlatform) system;

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  sha256 = {
    "x86_64-linux" = "bFoneLUA1to4dG7sOERnHOsEFWCzFolTse6qwZHTBpY=";
  }."${system}" or throwSystem;

in stdenv.mkDerivation rec {
  pname = "rustdesk";
  version = "1.1.8";

  src = fetchurl {
    url = "https://github.com/rustdesk/rustdesk/releases/download/${version}/rustdesk-${version}.deb";
    inherit sha256;
  };

  buildInputs = [
  ];

  nativeBuildInputs = [
    dpkg
    makeWrapper
    autoPatchelfHook
    glib
    gtk3
    pulseaudio
    alsa-lib
    xdotool
  ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out/
  '';

  meta = with lib; {
    description = "Yet another remote desktop software, written in Rust.";
    homepage = "https://rustdesk.com/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ x3ro ];
    platforms = [ "x86_64-linux" ];
  };
}
