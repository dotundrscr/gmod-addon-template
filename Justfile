DEPOT_TARGET_FOLDER := ".steam/steamcmd/linux32/steamapps/content/app_4000/depot_4002/"
TOOLS_PATH := absolute_path("tools/")
GAME_PATH := absolute_path("game/garrysmod")
STEP_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;203;166;247m"
ITEM_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;137;180;250m"
DONE_LOG_COLOR := "\\e[1;38;2;30;30;46;48;2;166;227;161m"

build: clean copy prepare-textures compile-models copy-compiled-models build-cleanup
    mv temp out

    @echo -e "{{ DONE_LOG_COLOR }}finished building the addon{{ NORMAL }}"

setup steam_login steam_password:
    @echo -e "{{ STEP_LOG_COLOR }}downloading sdk tools...{{ NORMAL }}"

    steamcmd +login {{ steam_login }} {{ steam_password }} +download_depot 4000 4002 +quit
    cp {{ join(home_directory(), DEPOT_TARGET_FOLDER) }} {{ TOOLS_PATH }} -r

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

clean:
    @echo -e "{{ STEP_LOG_COLOR }}cleaning up...{{ NORMAL }}"

    rm temp -rf
    rm out -rf

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

copy:
    @echo -e "{{ STEP_LOG_COLOR }}copying assets...{{ NORMAL }}"

    mkdir -p temp
    cp -r addon/* temp

    @echo -e "{{ DONE_LOG_COLOR }}finished copying assets{{ NORMAL }}"

    @echo -e "{{ STEP_LOG_COLOR }}copying models scripts...{{ NORMAL }}"

    for qcModel in $(find qc -name "*.qc"); do \
        echo -e "{{ ITEM_LOG_COLOR }}copying $qcModel...{{ NORMAL }}" && \
        cp $qcModel temp/$(basename $qcModel); \
    done

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

prepare-textures:
    @echo -e "{{ STEP_LOG_COLOR }}preparing textures...{{ NORMAL }}"

    for texture in $(find temp -name "*.tga"); do \
        echo -e "{{ ITEM_LOG_COLOR }}compiling $texture...{{ NORMAL }}" && \
        {{ join(TOOLS_PATH, "bin/vtex.exe") }} -nopause -game {{ GAME_PATH }} -outdir $(dirname $texture) $texture; \
    done

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

compile-models:
    @echo -e "{{ STEP_LOG_COLOR }}compiling models...{{ NORMAL }}"

    for qcModel in $(find temp -name "*.qc"); do \
        echo -e "{{ ITEM_LOG_COLOR }}compiling $(echo $qcModel | sed 's|^temp/||')...{{ NORMAL }}" && \
        {{ join(TOOLS_PATH, "bin/studiomdl.exe") }} -game {{ GAME_PATH }} $qcModel && \
        echo -e "{{ DONE_LOG_COLOR }}compiled $(echo $qcModel | sed 's|^temp/||'){{ NORMAL }}"; \
    done

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

copy-compiled-models:
    @echo -e "{{ STEP_LOG_COLOR }}copying compiled models...{{ NORMAL }}"

    cp -r game/garrysmod/models/ temp

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"

build-cleanup:
    @echo -e "{{ STEP_LOG_COLOR }}cleaning up...{{ NORMAL }}"

    for file in $(find temp -name "*.smd" -or -name "*.qc" -or -name "*.tga"); do \
        echo -e "{{ ITEM_LOG_COLOR }}removing $file...{{ NORMAL }}" && \
        rm $file; \
    done

    @echo -e "{{ STEP_LOG_COLOR }}removing gmod models folder...{{ NORMAL }}"
    rm {{ join(GAME_PATH, "models") }} -r

    @echo -e "{{ DONE_LOG_COLOR }}done{{ NORMAL }}"
