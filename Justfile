DEPOT_TARGET_FOLDER := ".steam/steamcmd/linux32/steamapps/content/app_4000/depot_4002/"
TOOLS_PATH := absolute_path("tools/")

setup steam_login steam_password:
    # download the windows depot for garry's mod
    steamcmd +login {{ steam_login }} {{ steam_password }} +download_depot 4000 4002 +quit
    # copy the downloaded depot to tools/
    cp {{ join(home_directory(), DEPOT_TARGET_FOLDER) }} {{ TOOLS_PATH }} -r
