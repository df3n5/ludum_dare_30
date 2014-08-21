NAME="glitch_switch"
pushd export


#linux
pushd linux/cpp
rm -rf "$NAME-linux"
cp -rf bin "$NAME-linux"
tar -czf "$NAME-linux.tar.gz" "$NAME-linux"
mv "$NAME-linux.tar.gz" ../../../
rm -rf "$NAME-linux"
popd

#linux64
pushd linux64/cpp
rm -rf "$NAME-linux64"
cp -rf bin "$NAME-linux64"
tar -czf "$NAME-linux64.tar.gz" "$NAME-linux64"
mv "$NAME-linux64.tar.gz" ../../../
rm -rf "$NAME-linux64"
popd

#windows
pushd windows/neko
rm -rf "$NAME-windows"
cp -rf bin "$NAME-windows"
zip -r "$NAME-windows.zip" "$NAME-windows"
mv "$NAME-windows.zip" ../../../
rm -rf "$NAME-windows"
popd

#mac64
pushd mac64/neko
rm -rf "$NAME-mac64.app"
cp -rf bin/GlitchSwitch.app "$NAME-mac64.app"
zip -r -y "$NAME-mac64.app.zip" "$NAME-mac64.app"
mv "$NAME-mac64.app.zip" ../../../
rm -rf "$NAME-mac64.app"
popd


popd #export
