{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [ pkgs.R ];

  shellHook = ''
    export R_LIBS_USER=$(pwd)/.R/library
    mkdir -p $R_LIBS_USER
    echo "Installing R packages..."
    Rscript -e "install.packages('MASS', repos='http://cran.rstudio.com/')"
  '';
}

