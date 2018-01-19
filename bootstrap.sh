#!/bin/bash
# ------------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2017 Jason Stafford
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ------------------------------------------------------------------------------

#   ---------------------------------------
#   BOOTSTRAP DEVELOPMENT ENVIRONMENT
#   ---------------------------------------

# path of directory containing the required<Entity>.txt files, for easier testing
currentDir="${HOME}/.scry-shell"

updateBootstrapReqs () {
  echo "updating bootstrap requriements . . . "
  if ! [ -d "${HOME}/.scry-shell" ]
  then
    git clone https://github.com/ScryCollective/scry-shell.git "${HOME}/.scry-shell"
  fi
  git -C "${HOME}/.scry-shell" pull
}

bootstrapBrew () {
  if ! hash brew 2>/dev/null
  then
   echo "starting Homebrew install . . . "
   /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
}

# command line applications
listInstalledBottles () {
  brew list -1
}

bootstrapBrewBottles () {
  local installedBrewBottles
  local requiredBottle
  echo "starting brew bottle bootstrap . . . "
  installedBrewBottles=($(listInstalledBottles))
  while IFS='' read -r requiredBottle || [[ -n "$requiredBottle" ]]
  do
    # echo Required: "${requiredBottle}"
    if ! [[ "${installedBrewBottles[*]}" =~ ${requiredBottle} ]]
    then
      echo "starting install of ${requiredBottle} . . . "
      brew install "${requiredBottle}"
    fi
  done < "${currentDir}/requiredBrewBottles.txt"
}

# graphical applications
listInstalledCasks () {
  brew cask list -1
}

bootstrapBrewCasks () {
  local installedBrewCasks
  local requiredCask
  echo "starting brew cask bootstrap . . . "
  installedBrewCasks=($(listInstalledCasks))
  # echo installed: "${installedBrewCasks[@]}"
  while IFS='' read -r requiredCask || [[ -n "$requiredCask" ]]
  do
    # echo Required: "${requiredCask}"
    if ! [[ "${installedBrewCasks[*]}" =~ ${requiredCask} ]]
    then
      echo "starting install of ${requiredCask} . . . "
      brew cask install "${requiredCask}"
    fi
  done < "${currentDir}/requiredBrewCasks.txt"
}

# python libraries
listInstalledWheels () {
  pip list --format=legacy | cut -d ' ' -f 1
}

bootstrapPythonWheels () {
  local installedWheels
  local requiredWheel
  echo "starting python wheel bootstrap . . . "
  installedWheels=($(listInstalledWheels))
  while IFS='' read -r requiredWheel || [[ -n "$requiredWheel" ]]
  do
    if ! [[ "${installedWheels[*]}" =~ ${requiredWheel} ]]
    then
      echo "starting install of ${requiredWheel} . . . "
      pip install "${requiredWheel}"
    fi
  done < "${currentDir}/requiredPythonWheels.txt"
}

# node libraries
listNodeModules () {
  npm list -g --depth=0 | tail +2 | cut -c5- | cut -d @ -f 1
}

bootstrapNodeModules () {
  local installedModules
  local requiredModule
  echo "starting node module bootstrap . . . "
  installedModules=($(listNodeModules))
  while IFS='' read -r requiredModule || [[ -n "$requiredModule" ]]
  do
    # use parameter expansion strip the @ sign and everything after the @
    # when checking if this module is installed
    if ! [[ "${installedModules[*]}" =~ ${requiredModule%%@*} ]]
    then
      echo "starting install of ${requiredModule} . . . "
      npm install -g "${requiredModule}"
    fi
  done  < "${currentDir}/requiredNodeModules.txt"
}

# atom extensions
listAtomPackages () {
  apm list --bare --installed | cut -d @ -f 1
}

bootstrapAtomPackages () {
  local installedAtomPackages
  local requiredPackage
  echo "starting atom package bootstrap . . . "
  installedAtomPackages=($(listAtomPackages))
  while IFS='' read -r requiredPackage || [[ -n "$requiredPackage" ]]
  do
    if ! [[ "${installedAtomPackages[*]}" =~ ${requiredPackage} ]]
    then
      echo "starting install of ${requiredPackage} . . . "
      apm install "${requiredPackage}"
    fi
  done < "${currentDir}/requiredAtomPackages.txt"
}

listChromeExtensions () {
for entry in "${HOME}/Library/Application Support/Google/Chrome/External Extensions"/*
do
  echo "${entry##*/}"
done
}

# google chrome extensions
bootstrapChromeExtensions () {
  local installedChromeExtensions
  local requiredExtension
  local jsonContents
  local extensionFilePath
  local extensionID
  echo "starting chrome extension bootstrap . . . "
  installedChromeExtensions=($(listChromeExtensions))
  jsonContents='{ "external_update_url": "https://clients2.google.com/service/update2/crx" }'
  while IFS='' read -r requiredExtension || [[ -n "$requiredExtension" ]]
  do
    # use parameter expansion strip the first space and everything after
    # to get just the extensionID
    extensionID=${requiredExtension%% *}
    if ! [[ "${installedChromeExtensions[*]}" =~ ${extensionID} ]]
    then
      echo "starting install of ${requiredExtension##* # } . . . "
      echo " ⚑⚑⚑ RESTART OF CHROME REQUIRED ⚑⚑⚑ "
      extensionFilePath="${HOME}/Library/Application Support/Google/Chrome/External Extensions/${extensionID}.json"
      echo "${jsonContents}" > "${extensionFilePath}"
    fi
  done < "${currentDir}/requiredChromeExtensions.txt"

}

bootstrap () {
  if [ -d "${1}" ]
  then
    currentDir="${1}"
  fi
  echo "starting bootstrap . . . "
  updateBootstrapReqs
  bootstrapBrew
  bootstrapBrewBottles
  bootstrapBrewCasks
  bootstrapPythonWheels
  bootstrapNodeModules
  bootstrapAtomPackages
  bootstrapChromeExtensions
}

listInstalled () {
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━┓"
  echo "┃      brew bottles       ┃"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━┛"
  listInstalledBottles
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━┓"
  echo "┃       brew casks        ┃"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━┛"
  listInstalledCasks
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━┓"
  echo "┃      python wheels      ┃"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━┛"
  listInstalledWheels
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━┓"
  echo "┃   global node modules   ┃"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━┛"
  listNodeModules
  echo "┏━━━━━━━━━━━━━━━━━━━━━━━━━┓"
  echo "┃      atom packages      ┃"
  echo "┗━━━━━━━━━━━━━━━━━━━━━━━━━┛"
  listAtomPackages
}
