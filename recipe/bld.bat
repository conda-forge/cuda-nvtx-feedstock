if "%TARGET_PLATFORM%" == "win-arm64" (
    set CUDA_ARCH=arm64
) else (
    set CUDA_ARCH=x64
)

if not exist %PREFIX% mkdir %PREFIX%
mkdir %LIBRARY_INC%\targets
mkdir %LIBRARY_INC%\targets\%CUDA_ARCH%

move include\nvtx3 %LIBRARY_INC%\targets\%CUDA_ARCH%
