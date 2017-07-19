#!/bin/bash

# Create required directory in case (optional) 
EXTENSIONS_DIR="$(jupyter --data-dir)/nbextensions"
if [[ ! -d "${EXTENSIONS_DIR?}" ]]; then
  mkdir -p "${EXTENSIONS_DIR?}"
fi

# Clone the repository 
if [[ ! -d "${EXTENSIONS_DIR?}/vim_binding" ]]; then
  pushd "${EXTENSIONS_DIR?}"
  git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding 
else
  pushd "${EXTENSIONS_DIR?}/vim_binding"
  git checkout master
  git pull
fi
popd
# Activate the extension 
jupyter nbextension enable vim_binding/vim_binding

CERTFILE="notebook.pem"
KEYFILE="notebook.key"
if ! [ -s "${CERTFILE?}" -a -s "${KEYFILE?}" ]; then
  echo "Generating ${CERTFILE?} and ${KEYFILE?}..."
  openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout "${KEYFILE?}" -out "${CERTFILE?}"
fi

source activate dl
jupyter notebook --certfile="${CERTFILE?}" --keyfile="${KEYFILE?}"
