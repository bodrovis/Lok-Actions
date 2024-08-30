#!/bin/bash

if [ ! -f ./bin/lokalise2 ]; then
  echo "Installing Lokalise CLI..."
  curl -sfL https://raw.githubusercontent.com/lokalise/lokalise-cli-2-go/master/install.sh | sh || {
      echo "Failed to install Lokalise CLI"
      exit 1
  }
else
  echo "Lokalise CLI already installed, skipping installation."
fi
