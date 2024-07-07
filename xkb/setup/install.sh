#!/usr/bin/zsh

if [ `id -u` != 0 ]; then
  echo "This script must be run as root, as it will modify"
  echo "system-wide layout files to install anterak."
  exit
fi

RT=/usr/share/X11/xkb

# Remember the current directory to restore at the end and go
# to a known directory.
pushd `pwd` > /dev/null
cd `dirname $0`
cd ..

# Copy the symbol file.
echo "Copying symbols to ${RT}/symbols/anterak"
cp symbols/anterak ${RT}/symbols
chmod 644 ${RT}/symbols/anterak

# Copy the types file.
echo "Copying types to ${RT}/symbols/anterak"
cp types/anterak ${RT}/types
chmod 644 ${RT}/types/anterak

# Add the geometries.
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
  if [[ -f ${RT}/${file} ]]; then
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
  fi
  cat ${file} >> tmp_geometries

  savefile=setup/geometry.`basename $file`.save
  if [[ -f ${RT}/${file} ]]; then
    cp ${RT}/${file} ${savefile}
  fi

  mv tmp_geometries ${RT}/${file}
done

# Add the rules.
grep anterak ${RT}/rules/evdev > /dev/null
if [ $? = 0 ]; then
  echo "Rules already found in the rules file, not adding them again"
else
  echo "Adding rules to ${RT}/rules/evdev"
  echo >> ${RT}/rules/evdev.lst
  cat rules/evdev >> ${RT}/rules/evdev
fi

# Add the definition alias to legacy files
grep anterak ${RT}/rules/evdev.lst > /dev/null
if [ $? = 0 ]; then
  echo "Definition already found in the rules file, not adding it again"
else
  echo "Adding definiton to ${RT}/rules/evdev.lst"
  echo >> ${RT}/rules/evdev.lst
  cat rules/evdev.lst >> ${RT}/rules/evdev.lst
fi

# Add the definition alias to xml files, to make it visible to desktop environments.
add_to_xml() {
  file=$1
  grep anterak $file > /dev/null
  if [ $? = 0 ]; then
    echo "Found definition in $file, not adding it again"
    return
  fi
  savefile=setup/`basename $file`.save
  cp $file $savefile
  echo "Adding definition to $file. Old version saved to $savefile"
  l=`grep -n '</layoutList>' $file | cut -d : -f 1`
  head -n $((l-1)) $file > tmp_rules
  cat rules/evdev.xml.part >> tmp_rules
  tail -n +$l $file >> tmp_rules
  mv tmp_rules $file
}
add_to_xml ${RT}/rules/base.xml
add_to_xml ${RT}/rules/evdev.xml
# Remove cached compiled keymaps, or your change may not be seen.
rm -f /var/lib/xkb/*.xkm(N)

# Restore original directory
popd > /dev/null
