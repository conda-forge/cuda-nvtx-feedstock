#!/bin/bash

# Install to conda style directories
[[ -d lib64 ]] && mv lib64 lib
mkdir -p ${PREFIX}/lib
[[ -d pkg-config ]] && mkdir -p ${PREFIX}/lib && mv pkg-config ${PREFIX}/lib/pkgconfig
[[ -d "$PREFIX/lib/pkgconfig" ]] && sed -E -i "s|cudaroot=.+|cudaroot=$PREFIX|g" $PREFIX/lib/pkgconfig/nvToolsExt*.pc

[[ ${target_platform} == "linux-64" ]] && targetsDir="targets/x86_64-linux"
[[ ${target_platform} == "linux-ppc64le" ]] && targetsDir="targets/ppc64le-linux"
[[ ${target_platform} == "linux-aarch64" ]] && targetsDir="targets/sbsa-linux"

for i in `ls`; do
    [[ $i == "build_env_setup.sh" ]] && continue
    [[ $i == "conda_build.sh" ]] && continue
    [[ $i == "metadata_conda_debug.yaml" ]] && continue
    if [[ $i == "lib" ]] || [[ $i == "include" ]]; then
        # Headers and libraries are installed to targetsDir
        mkdir -p ${PREFIX}/${targetsDir}
        mkdir -p ${PREFIX}/$i
        if [[ $i == "lib" ]]; then
            cp -rv $i ${PREFIX}/
            mkdir -p ${PREFIX}/${targetsDir}/lib
            for j in "$i"/*.so*; do
                # Shared libraries are symlinked in $PREFIX/lib
                ln -s ${PREFIX}/$j ${PREFIX}/${targetsDir}/$j
            done
        else
            cp -rv $i ${PREFIX}/${targetsDir}
        fi
    else
        # Put all other files in targetsDir
        mkdir -p ${PREFIX}/${targetsDir}/${PKG_NAME}
        cp -rv $i ${PREFIX}/${targetsDir}/${PKG_NAME}
    fi
done
