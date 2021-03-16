{ lib, stdenv, writeScriptBin, makeDesktopItem, nodePackages
, electron, xdg-utils
, basePkg, desktopName }:

let
  binaryName = "${basePkg.pname}-native";
in stdenv.mkDerivation rec {
  pname = "${basePkg.pname}-native-electron";
  version = basePkg.version;

  inherit (basePkg) src;

  buildInputs = [ electron xdg-utils ];
  nativeBuildInputs = [ nodePackages.asar ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    libpath="$out/lib/$pname"
    install -d "$libpath"

    # patch the asar to work with system electron
    asar e resources/app.asar resources/app
    rm resources/app.asar
    sed -i "s|process.resourcesPath|'$libpath'|" resources/app/app_bootstrap/buildInfo.js
    sed -i "s|exeDir,|'$out/share/pixmaps',|" resources/app/app_bootstrap/autoStart/linux.js
    asar p resources/app resources/app.asar --unpack-dir '**'
    rm -rf resources/app

    # copy resources
    cp -t "$libpath" -r resources/*

    # wrapper script
    install -d "$out"/bin

    bname="$out/bin/${binaryName}"
    echo > "$bname" "#!${stdenv.shell}"
    echo >>"$bname" "exec '${electron}/bin/electron' '$libpath'/app.asar \$@" 
    chmod a+x "$bname"

    # install icon
    install -D -t $out/share/pixmaps discord.png

    ln -t $out/share -s "${desktopItem}"/share/applications
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = binaryName;
    icon = basePkg.pname;
    inherit desktopName;
    genericName = basePkg.meta.description;
    categories = "Network;InstantMessaging;";
    mimeType = "x-scheme-handler/discord";
  };

  meta = with lib; {
    description = "Discord repackaged to use the system Electron version";
    inherit (basePkg.meta) homepage downloadPage license platforms;
    maintainers = with maintainers; [ anna328p ];
  };
}
