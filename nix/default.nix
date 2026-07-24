{ pkgs ? import <nixpkgs> {} }:

pkgs.rustPlatform.buildRustPackage {
  pname = "idle";
  version = "2.3.8";

  src = pkgs.fetchFromGitHub {
    owner = "idlescreen";
    repo = "idle";
    rev = "v2.3.8";
    hash = pkgs.lib.fakeHash;
  };

  cargoHash = pkgs.lib.fakeHash;

  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = [ pkgs.dbus pkgs.wayland pkgs.libxkbcommon ];

  meta = with pkgs.lib; {
    description = "Wayland-native idle screen and ambient display for Linux";
    homepage = "https://github.com/idlescreen/idle";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
