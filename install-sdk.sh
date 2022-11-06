#!/bin/bash
curl -s "https://get.sdkman.io" | bash
chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install kotlin
sdk install gradle

# Kotlin language server
git clone https://github.com/fwcd/kotlin-language-server $HOME/kotlin-language-server
cd $HOME/kotlin-language-server
./gradlew :server:installDist
sudo mkdir -p /usr/local/bin
sudo mv server/build/install/server/bin/kotlin-language-server /usr/local/bin/