# ----------------------------------------------------------------------------
#
# Package       : Kotlin (stdlib & stdlib-common)
# Version       : 1.3.61
# Source repo   : https://github.com/JetBrains/kotlin.git
# Tested on     : UBI:8.3
# Script License: Apache License, Version 2 or later
# Maintainer    : Srividya Chittiboina <Srividya.Chittiboina@ibm.com>
#
# Disclaimer: This script has been tested in root mode on given
# ==========  platform using the mentioned version of the package.
#             It may not work as expected with newer versions of the
#             package and/or distribution. In such case, please
#             contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
#!/bin/bash

set -e

VERSION=${1:-v1.3.61}

yum install -y wget git patch

useradd -G root -d /home/testuser testuser -p test123

su testuser
cd 

wget https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u302-b08/OpenJDK8U-jdk_ppc64le_linux_hotspot_8u302b08.tar.gz
tar xf OpenJDK8U-jdk_ppc64le_linux_hotspot_8u302b08.tar.gz

wget https://github.com/AdoptOpenJDK/openjdk9-binaries/releases/download/jdk-9.0.4%2B11/OpenJDK9U-jdk_ppc64le_linux_hotspot_9.0.4_11.tar.gz
tar xf OpenJDK9U-jdk_ppc64le_linux_hotspot_9.0.4_11.tar.gz

rm -rf OpenJDK8U-jdk_ppc64le_linux_hotspot_8u302b08.tar.gz OpenJDK9U-jdk_ppc64le_linux_hotspot_9.0.4_11.tar.gz

export JAVA_HOME=$HOME/jdk8u302-b08
export JDK_9=$HOME/jdk-9.0.4+11
export JDK_16=$JAVA_HOME
export JDK_17=$JAVA_HOME
export JDK_18=$JAVA_HOME
export PATH=$JAVA_HOME/bin:$PATH

wget https://raw.githubusercontent.com/ppc64le/build-scripts/master/k/kotlin-stdlib/v1.3.61/kotlin.patch

git clone https://github.com/JetBrains/kotlin.git
cd kotlin
git checkout $VERSION
patch -p1 < $HOME/kotlin.patch

./gradlew  :kotlin-stdlib-common:test 
./gradlew :kotlin-stdlib:test

echo "JARS at  "
find -name *kotlin-stdlib*SNAPSHOT.jar