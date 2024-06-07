#!/bin/bash

remove_spritesheet() {
    # Get the parameters
    file=$1
    
    # Remove the file if exists
    if [ -e "${file}" ]; then
        rm "${file}"
    fi
}

make_spritesheets() {
    # Get the parameters
    basedir=$1
    suffix=$2

    # Define the list of subdirectories
    animations=("attacking" "running" "dying")
    subdirs=("angle_0" "angle_90" "angle_180" "angle_270")


    # Create the postprocessed directory if not exists
    if [ ! -d "${basedir}/processed" ]; then
        mkdir "${basedir}/processed"
    fi


    # Loop through animation types
    for anim in "${animations[@]}"; do
        # Loop through each subdirectory
        for dir in "${!subdirs[@]}"; do
            # Set the output sheet name
            sheet="dragon_${anim}${suffix}_${dir}.png"

            # Change to the current subdirectory
            cd "$basedir/$anim/${subdirs[$dir]}" || exit 1

            # Remove previous spritesheet if exists
            remove_spritesheet "${basedir}/${sheet}"
            remove_spritesheet "${basedir}/processed/${sheet}"

            # Let ImageMagick do the magic
            montage "*" -geometry 500x500 -tile 10x10 -background transparent -filter Catrom "${basedir}/${sheet}"
            magick "${basedir}/${sheet}" -modulate 100,130,100 -level 10% "${basedir}/processed/${sheet}"

            # Clean up temporary spritesheet
            remove_spritesheet "${basedir}/${sheet}"

            # Change back to the original directory
            cd $basedir
        done
    done
}

an="/media/Data/codebase/factorio/here-be-dragons/working/animation"
sh="/media/Data/codebase/factorio/here-be-dragons/working/shadow"

make_spritesheets $an
make_spritesheets $sh "_shadow"