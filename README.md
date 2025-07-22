# Dockerized Abiotic Factor dedicated server in an Ubuntu 24.04 container with Wine

[![GitHub Actions](https://github.com/AndrewSav/abiotic-factor-linux-docker/actions/workflows/main.yml/badge.svg)](https://github.com/AndrewSav/abiotic-factor-linux-docker/actions)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/andrewsav/abiotic-factor?sort=semver)](https://hub.docker.com/r/andrewsav/abiotic-factor/tags)

*This is a fork of <https://github.com/Pleut/abiotic-factor-linux-docker>. If the original is working fine for you keep using that. The list of changes comparing to the original can be found below.*

**I strongly suggest to start with [official Abiotic Factor dedicated server wiki](https://github.com/DFJacob/AbioticFactorDedicatedServer/wiki), they list and explain the server settings, I will assume you are already familiar with these below.**

## Environment variables


| Variable    | Description                                                  |
| ----------- | ------------------------------------------------------------ |
| args | this is the command line for the abiotic factor dedicated server executable. Possible arguments are listed on the wiki linked above |
| SKIP_UPDATE | if provided, skips the Steam update process on container startup |


## Ports


| Exposed Container port | Type | Default |
| ------------------------ | ------ | --------- |
| 7777                | UDP  | ✔   |
| 27015              | UDP  | ✔   |

In order for others to connect to your server you will most likely need to configure port forwarding on your router.

## Volumes

| Volume             | Container path              | Description                             |
| -------------------- | ----------------------------- | ----------------------------------------- |
| Steam install path | /server   | the server files are downloaded into this directory, and settings files are created here on the first start. server logs and saves are located under /server/AbioticFactor/Saved |

## Starting the server

Review `docker-compose.yml`, make sure that the server parameters are what you want them to be.

In the folder containing `docker-compose.yml` run

```bash
docker compose up -d --force-recreate
```

You can watch the logs with:

```bash
docker compose logs -f
```

*Note: this readme assumes that you are using supplied `docker-compose.yml` to start the server. Some parts of this readme may be inaccurate if your settings differ from the provided.*

## Server configuration

The server is configured via command line parameters passed to the server executable, exposed as the `args` environment variable. 

*Note: the `args` environment variable in `docker-compose.yml` is a single line value that is presented in multi-line format with the `>-` yml feature. Be careful when editing it, as `#` comments inside it might not work as one would expect. Refer to the yml specification if in doubt for the details on how yml format works*.

There are also Logs are found in `./server/AbioticFactor/Saved/Logs/` directory, and Saves are in `./server/AbioticFactor/Saved/SaveGames/` directory. You can now connect to your server from the game (providing that the port forwarding is set up correctly).

Additionally, the server allows to configure some settings via `Admin.ini` and `SandboxSettings.ini` files.

*Note: read the official notes linked at the top of this README, they will tell you the command line arguments that can be used with the server to configure it, and give more details about the setting files*

## Connecting to the server

In game, after clicking "Join a Server", use "Direct Connect" button, IP Address section. Enter the server IP or domain name and the port number in the format prompted on that screen, and enter password if any. Click "Join". You can also join via an lobby code. The lobby code is dumped in the container log, you can search for it with `docker compose logs | grep code:` after the server has completed start up. Finally you can find your server in the server list on the "Join a Server" screen. Leave all the checkboxes ticked, and put your full server name as specified in the `SteamServerName` command line parameter into the search box and click "Apply".

## Updating the server

Restart the container. It will check steam for the newer server version on start and update if required. My preferred method of restarting is running `docker compose up -d --force-recreate` but simple `docker restart abiotic-factor` would suffice. 

## Additional Information

## Changing port

If you change port in `docker-compose.yaml` from `7777` to somethings else, e.g.:

```yaml
    ports:
      - '12345:12345/udp'
```

*Note: the port number that the dedicated server uses should match the port numbers exposed externally via port forwarding.*

### Port forwarding

Detailed port forwarding guide is out of scope of this document, there are a lot of variations between routers in how this is done. However here is a few important point to keep in mind:

- You need to forward ports `7777`  and `27015` (unless you changed it to something else) on UDP protocol. Without this your server won't be accessible from the internet. You can use <https://afcheck.bat.nz/> to check if your server is accessible.
- It is possible, that the server is accessible from the internet but not from the same (home) network where your server is in. This is called a hairpin NAT problem. Either google how to configure it on your router (if it supports it), or use local IP address for connecting to the server within the same network (as opposed to your external IP address).
- Some internet providers employ [CGNAT](https://en.wikipedia.org/wiki/Carrier-grade_NAT). If yours does, you won't be able to make your server accessible externally, unless you and other users use a VPN or a tunneling service such as <https://playit.gg/> (this is not an endorsement, I have never used this service myself).

## About this fork

- Graceful termination. The server does not do save upon termination, unless manually trigger by an admin in game, so the only difference that it terminates much faster
- Suppressed error on start about steam folder
- The changed docker image is at `andrewsav/abiotic-factor`
- Renamed docker-compose.yml.example back to docker-compose.yml
- Container name is set in docker-compose for a shorter name
- Saved game folder in `docker-compose.yml` is not shared separately since it's already shared under `./server`
- The Auto update variable in `docker-compose.yml` changed to `SKIP_UPDATE` and is not set by default
- Removed most of the Environment Variables in favor of a single command line string to get rid of the concatenation code and simplify
- Minor changes in `Dockerfile` to be consistent with my other game server docker images

## About this docker image

See [APPROACH.md](https://github.com/AndrewSav/moria-docker/blob/main/APPROACH.md)

## Credits
Thanks to @Pleut for the original implementation
