{ stdenv, fetchurl, fetchFromGitHub, requireFile
, SDL2, SDL2_mixer, cmake, ninja
, fullGame ? false }:

let
  dataZip = if fullGame then requireFile {
    # the data file for the full game
    name = "data.zip";
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
    message = ''
      In order to install VVVVVV, you must first download the game's
      data file (data.zip) as it is not released freely.
      Once you have downloaded the file, place it in your current
      directory, use the following command and re-run the installation:
      nix-prefetch-url file://\$PWD/data.zip
    '';
  } else fetchurl {
    # the data file for the free Make and Play edition
    url = https://thelettervsixtim.es/makeandplay/data.zip;
    sha256 = "1q2pzscrglmwfgdl8yj300wymwskh51iq66l4xcd0qk0q3g3rbkg";
  };

  # if the user does not own the full game, build the Make and Play edition
  flags = if fullGame then [] else [ "-DMAKEANDPLAY" ];
in stdenv.mkDerivation rec {
  pname = "vvvvvv";
  version = "2.3-git-2020-01-22";

  src = fetchFromGitHub {
    owner = "TerryCavanagh";
    repo = "VVVVVV";
    rev = "90cab340f123f1a355f638c47b677c6572a514b2";
    sha256 = "1bq7kj33pw1dwsgh0s0pqayfyhpnbvpgw2c1w9scpl5l0hkhg44p";
  };

  CFLAGS = flags;
  CXXFLAGS = flags;

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ SDL2 SDL2_mixer ];

  sourceRoot = "source/desktop_version";

  installPhase = ''
    install -d $out/bin
    install -t $out/bin VVVVVV
    install -T ${dataZip} $out/bin/data.zip
  '';

  meta = with stdenv.lib; {
    description = "A retro-styled platform game";
    longDescription = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping? 
    '';
    homepage = "https://thelettervsixtim.es";
    license = if fullGame then licenses.unfree else licenses.unfreeRedistributable;
    maintainers = [ maintainers.dkudriavtsev ];
    platforms = platforms.all;
  };
}
