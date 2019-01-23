@echo off
xcopy /s "CMakeLists.txt" "../libB/CMakeLists.txt"
gen_cmake -DCMAKE_INSTALL_PREFIX=./deploy