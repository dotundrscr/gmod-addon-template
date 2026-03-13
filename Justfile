DEPOT_TARGET_FOLDER := ".steam/steamcmd/linux32/steamapps/content/app_4000/depot_4002/"
TOOLS_PATH := absolute_path("tools/")
GAME_PATH := absolute_path("game/garrysmod")
LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;203;166;247m"

build: prepare-textures prepare-models

setup steam_login steam_password:
    @echo "{{ style('command') }}downloading sdk tools...{{ NORMAL }}"

    steamcmd +login {{ steam_login }} {{ steam_password }} +download_depot 4000 4002 +quit
    cp {{ join(home_directory(), DEPOT_TARGET_FOLDER) }} {{ TOOLS_PATH }} -r

prepare-textures:
    @echo -e "{{ LOG_COLOR }}preparing textures...{{ NORMAL }}"

    mkdir -p temp

    for texture in $(find assets -name "*.tga"); do \
        {{ join(TOOLS_PATH, "bin/vtex.exe") }} -nopause -game {{ GAME_PATH }} -outdir "temp/$(dirname $texture | sed 's|^assets/||')" $texture; \
    done

    for material in $(find assets -name "*.vmt"); do \
        mkdir -p temp/$(dirname $material | sed 's|^assets/||') && \
        cp $material temp/$(dirname $material | sed 's|^assets/||'); \
    done

prepare-models:
    @echo -e "{{ LOG_COLOR }}preparing models...{{ NORMAL }}"

    mkdir -p temp

    for model in $(find assets -name "*.smd"); do \
        mkdir -p temp/$(dirname $model | sed 's|^assets/||') && \
        cp $model temp/$(dirname $model | sed 's|^assets/||'); \
    done

    for qcModel in $(find qc -name "*.qc"); do \
        cp $qcModel temp/$(basename $qcModel); \
    done
