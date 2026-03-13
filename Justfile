DEPOT_TARGET_FOLDER := ".steam/steamcmd/linux32/steamapps/content/app_4000/depot_4002/"
TOOLS_PATH := absolute_path("tools/")
GAME_PATH := absolute_path("game/garrysmod/")
TEMP_PATH := absolute_path("temp/")
OUT_PATH := absolute_path("out/")
SRC_PATH := absolute_path("addon/")
STEP_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;203;166;247m"
ITEM_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;137;180;250m"
DONE_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;166;227;161m"

build: clean copy prepare-textures compile-models copy-compiled-models build-cleanup
    mv {{ TEMP_PATH }} {{ OUT_PATH }}

    @echo -e "{{ DONE_LOG_COLOR }}finished building the addon{{ NORMAL }}"

setup steam_login steam_password:
    @echo -e "{{ STEP_LOG_COLOR }}downloading sdk tools...{{ NORMAL }}"

    steamcmd +login {{ steam_login }} {{ steam_password }} +download_depot 4000 4002 +quit
    cp {{ join(home_directory(), DEPOT_TARGET_FOLDER) }} {{ TOOLS_PATH }} -r

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

clean:
    @echo -e "{{ STEP_LOG_COLOR }}cleaning up...{{ NORMAL }}"

    rm {{ TEMP_PATH }} -rf
    rm {{ OUT_PATH }} -rf

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

copy:
    @echo -e "{{ STEP_LOG_COLOR }}copying assets...{{ NORMAL }}"

    mkdir -p {{ TEMP_PATH }}
    cp -r {{ SRC_PATH }}/* {{ TEMP_PATH }}

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

prepare-textures:
    @echo -e "{{ STEP_LOG_COLOR }}preparing textures...{{ NORMAL }}"

    for texture in $(find {{ TEMP_PATH }} -name "*.tga"); do \
        echo -e "{{ ITEM_LOG_COLOR }}compiling $(echo $texture | sed 's|^{{ TEMP_PATH }}/||')...{{ NORMAL }}" && \
        {{ join(TOOLS_PATH, "bin/vtex.exe") }} -nopause -game {{ GAME_PATH }} -outdir $(dirname $texture) $texture; \
    done

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

compile-models:
    @echo -e "{{ STEP_LOG_COLOR }}compiling models...{{ NORMAL }}"

    for qcModel in $(find {{ TEMP_PATH }} -name "*.qc"); do \
        echo -e "{{ ITEM_LOG_COLOR }}compiling $(echo $qcModel | sed 's|^{{ TEMP_PATH }}/||')...{{ NORMAL }}" && \
        {{ join(TOOLS_PATH, "bin/studiomdl.exe") }} -game {{ GAME_PATH }} $qcModel && \
        echo -e "{{ DONE_LOG_COLOR }}compiled $(echo $qcModel | sed 's|^{{ TEMP_PATH }}/||'){{ NORMAL }}"; \
    done

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

copy-compiled-models:
    @echo -e "{{ STEP_LOG_COLOR }}copying compiled models...{{ NORMAL }}"

    cp -r {{ join(GAME_PATH, "models") }} {{ TEMP_PATH }}

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

build-cleanup:
    @echo -e "{{ STEP_LOG_COLOR }}cleaning up...{{ NORMAL }}"

    for file in $(find {{ TEMP_PATH }} -name "*.smd" -or -name "*.qc" -or -name "*.tga"); do \
        echo -e "{{ ITEM_LOG_COLOR }}removing $(echo $file | sed 's|^{{ TEMP_PATH }}/||')...{{ NORMAL }}" && \
        rm $file; \
    done

    @echo -e "{{ STEP_LOG_COLOR }}removing gmod models folder...{{ NORMAL }}"
    rm {{ join(GAME_PATH, "models") }} -r

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"
