#!/usr/bin/zsh

RT=/usr/share/X11/xkb

# Remember the current directory to restore at the end and go
# to a known directory.
pushd `pwd` > /dev/null
cd `dirname $0`
cd ..

for file in geometry/*; do
    print "Installing $file"

    geometries=()
    grep xkb_geometry $file | while read g; do
        g=${${g##xkb_geometry \"}%%\" *}
        geometries+=$g
    done

    print "Found geometries $geometries"

    rm -f tmp_geometries
    accept=1
    # `read` will split according to $IFS and there doesn't seem to be an option to prevent that
    IFS=
    cat ${RT}/${file} | while read i; do
        for g in $geometries; do
            if [[ $i = "xkb_geometry \"$g\""* ]]; then
                print "Removing geometry $g"
                accept=0
            fi
        done

        if [[ $accept = 1 ]]; then
            print $i >> tmp_geometries
        fi

        for g in $geometries; do
            if [[ $i = *"// End of \"$g\""* ]]; then
                print "End of geometry $g"
                accept=1
            fi
        done
    done
    cat ${file} >> tmp_geometries

    mv tmp_geometries ${RT}/${file}
done

# Restore original directory
popd > /dev/null
