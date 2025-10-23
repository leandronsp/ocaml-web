{
  inputs = {
    nixpkgs.url = "github:nix-ocaml/nix-overlays";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_3;
    in {
      devShell = pkgs.mkShell {
        nativeBuildInputs = with ocamlPackages; [
          ocaml
          dune_3
          ocaml-lsp
          ocamlformat
          findlib
        ];

        propagatedBuildInputs = with ocamlPackages; [
          lwt
          dream
          caqti
          caqti-lwt
          caqti-driver-postgresql
        ];
      };
      formatter = pkgs.alejandra;
    });
}
