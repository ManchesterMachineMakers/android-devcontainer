#!/bin/bash
curl -s "https://get.sdkman.io" | bash
chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh"
source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 17-open
sdk install kotlin
sdk install gradle