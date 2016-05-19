#!/bin/bash

if [[ ! -d "${HOME}/.devscripts" ]] ; then
  echo "Creating ${HOME}/.devscripts"
  mkdir "${HOME}/.devscripts"
fi
echo "Installing scripts in ${HOME}/.devscripts"
cp -r scripts/* "${HOME}/.devscripts"

if [[ ! -f "${HOME}/.bashrc" ]] ; then
  echo "No ${HOME}/.bashrc found; creating."
  touch "${HOME}/.bashrc"
fi
EXPORT_PATH="export PATH=\$PATH:${HOME}/.devscripts"
if [[ ! "$(grep "$EXPORT_PATH" "${HOME}/.bashrc"| sed -e 's/\W//g')" ]] ; then
  echo "Adding ${HOME}/.devscripts to \$PATH"
  echo -ne "\n#Dev scripts\n$EXPORT_PATH\n" >> "${HOME}/.bashrc"
fi

echo "Done. Please log out and in again for changes to take effect, or run:"
echo "    . ~/.bashrc"
