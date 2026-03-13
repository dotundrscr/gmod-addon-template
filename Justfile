DEPOT_TARGET_FOLDER := ".steam/steamcmd/linux32/steamapps/content/app_4000/depot_4002/"
TOOLS_PATH := absolute_path("tools/")
GAME_PATH := absolute_path("game/garrysmod")
STEP_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;203;166;247m"
ITEM_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;137;180;250m"
DONE_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;166;227;161m"

build: prepare-textures prepare-models
    @echo -e "{{ DONE_LOG_COLOR }}finished building the addon{{ NORMAL }}"

setup steam_login steam_password:
    @echo -e "{{ STEP_LOG_COLOR }}downloading sdk tools...{{ NORMAL }}"

    steamcmd +login {{ steam_login }} {{ steam_password }} +download_depot 4000 4002 +quit
    cp {{ join(home_directory(), DEPOT_TARGET_FOLDER) }} {{ TOOLS_PATH }} -r

    @echo -e "{{ DONE_LOG_COLOR }}finished downloading{{ NORMAL }}"

prepare-textures:
    @echo -e "{{ STEP_LOG_COLOR }}preparing textures...{{ NORMAL }}"

    mkdir -p temp

    for texture in $(find assets -name "*.tga"); do \
        echo -e "{{ ITEM_LOG_COLOR }}compiling $texture...{{ NORMAL }}" && \
        {{ join(TOOLS_PATH, "bin/vtex.exe") }} -nopause -game {{ GAME_PATH }} -outdir "temp/$(dirname $texture | sed 's|^assets/||')" $texture; \
    done

    for material in $(find assets -name "*.vmt"); do \
        echo -e "{{ ITEM_LOG_COLOR }}copying $material...{{ NORMAL }}" && \
        mkdir -p temp/$(dirname $material | sed 's|^assets/||') && \
        cp $material temp/$(dirname $material | sed 's|^assets/||'); \
    done

    @echo -e "{{ DONE_LOG_COLOR }}finished preparing textures{{ NORMAL }}"

prepare-models:
    @echo -e "{{ STEP_LOG_COLOR }}preparing models...{{ NORMAL }}"

    mkdir -p temp

    for model in $(find assets -name "*.smd"); do \
        echo -e "{{ ITEM_LOG_COLOR }}copying $model...{{ NORMAL }}" && \
        mkdir -p temp/$(dirname $model | sed 's|^assets/||') && \
        cp $model temp/$(dirname $model | sed 's|^assets/||'); \
    done

    for qcModel in $(find qc -name "*.qc"); do \
        echo -e "{{ ITEM_LOG_COLOR }}copying $qcModel...{{ NORMAL }}" && \
        cp $qcModel temp/$(basename $qcModel); \
    done

    @echo -e "{{ DONE_LOG_COLOR }}finished preparing models{{ NORMAL }}"
