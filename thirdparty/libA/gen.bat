@echo off
xcopy /y "CMakeLists.txt" "../libB/CMakeLists.txt"
gen_cmake -DCMAKE_INSTALL_PREFIX=./deploy