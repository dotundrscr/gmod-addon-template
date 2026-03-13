# gmod addon template

an attempt at a self-contained platform-independent template for gmod addons

## requirements
- [`steamcmd`](https://developer.valvesoftware.com/wiki/SteamCMD)
- [`just`](https://github.com/casey/just)

## getting started
download the repo in whatever way you prefer. cloning it looks like this:
```bash
git clone https://git.braindead.cc/dot/gmod-addon-template --recursive
```

> [!NOTE]
> *what is `--recursive`?* 
>
> `--recursive` pulls all submodules provided by the repo. this is required
> because [`github:Facepunch/garrysmod`](https://github.com/Facepunch/garrysmod)
> submodule provides the `gameinfo.txt` required by most of the SDK tools

from here you have 2 options:
- run `just setup (steam login) (steam password)`
- setup everything manually

### manual setup
run the following command:
```bash
steamcmd +login (steam login) (steam password) +download_depot 4000 4002 +quit
```
this will download the windows depot of gmod with the SDK tools
(`studiomdl`, `vtex`, etc.) to
`$HOME/.steam/steamcmd/linux32/steamapps/content/app_4000/depot_4002/`.
then copy the contents to `./tools/`. same commands are run by `just setup`
