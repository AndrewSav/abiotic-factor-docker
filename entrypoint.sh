#!/bin/bash

mkdir -p /root/.steam 2>&1

if [ -z "$SKIP_UPDATE" ] || [ ! -f "${s}/AbioticFactorServer.exe" ]; then
    if [ -n "$SKIP_UPDATE" ] && [ ! -f "${s}/AbioticFactorServer.exe" ]; then
        echo "[entrypoint] SKIP_UPDATE is set but server files are missing. Forcing update..."
    fi
    echo "[entrypoint] Updating Abiotic Factor Dedicated Server files with steamcmd..."
    if ! (r=5; while ! /usr/bin/steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir /server +login anonymous +app_update 2857200 validate +quit ; do
              ((--r)) || exit
              echo "[entrypoint] something went wrong, let's wait 5 seconds and retry"
              sleep 5
          done) ; then
        echo "[entrypoint] failed updating with steamcmd!"
        exit 1
    fi
else
    echo "[entrypoint] Skipping update as SKIP_UPDATE is set"
fi

exec wine /server/AbioticFactor/Binaries/Win64/AbioticFactorServer-Win64-Shipping.exe $args
