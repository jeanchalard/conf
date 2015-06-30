#!/bin/sh

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

# Restore original directory
popd > /dev/null
