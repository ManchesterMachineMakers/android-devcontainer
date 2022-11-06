#!/bin/bash
curl -s "https://get.sdkman.io" | bash
chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
source "$HOME/.sdkman/bin/sdkman-init.sh"

sudo apt install openjdk-17-jdk
sdk install kotlin
sdk install gradle