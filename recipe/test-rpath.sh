#!/bin/bash

[[ ${target_platform} == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ ${target_platform} == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ ${target_platform} == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

for lib in `find ${PREFIX}/${targetsDir}/lib -type f`; do
    [[ $lib =~ \.so ]] || continue

    rpath=$(patchelf --print-rpath $lib)
    echo "$lib rpath: $rpath"
    [[ $rpath == "\$ORIGIN" ]] || exit 1
done

exit 0
