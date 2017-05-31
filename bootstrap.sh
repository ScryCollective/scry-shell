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

# from http://stackoverflow.com/questions/3685970/check-if-an-array-contains-a-value
elementIn () {
 local e
 for e in "${@:2}"
 do
   [[ "${e}" == "${1}" ]] && return 0
 done
 return 1
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
  for requiredBottle in "${requiredBottles[@]}"
  do
    if ! elementIn "${requiredBottle}" "${installedBrewBottles[@]}"
    then
      echo "starting install of ${requiredBottle} . . . "
      brew install "${requiredBottle}"
    fi
  done
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
  for requiredCask in "${requiredCasks[@]}"
  do
    if ! elementIn "${requiredCask}" "${installedBrewCasks[@]}"
    then
      echo "starting install of ${requiredCask} . . . "
      brew cask install "${requiredCask}"
    fi
  done
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
  for requiredWheel in "${requiredWheels[@]}"
  do
    if ! elementIn "${requiredWheel}" "${installedWheels[@]}"
    then
      echo "starting install of ${requiredWheel} . . . "
      pip install "${requiredWheel}"
    fi
  done
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
  for requiredModule in "${requiredModules[@]}"
  do
    # use parameter expansion strip the @ sign and everything after the @
    # when checking if this module is installed
    if ! elementIn "${requiredModule%%@*}" "${installedModules[@]}"
    then
      echo "starting install of ${requiredModule} . . . "
      npm install -g "${requiredModule}"
    fi
  done
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
  for requiredPackage in "${requiredPackages[@]}"
  do
    if ! elementIn "${requiredPackage}" "${installedAtomPackages[@]}"
    then
      echo "starting install of ${requiredPackage} . . . "
      apm install "${requiredPackage}"
    fi
  done
}

# google chrome extensions
bootstrapGoogleExtensions () {
  local prefContents
  local prefFilePath
  local extensionID
  echo "starting google extension bootstrap . . . "
  prefContents='{ "external_update_url": "https://clients2.google.com/service/update2/crx" }'
  for extensionID in "${requiredExtensions[@]}"
  do
    prefFilePath="${HOME}/Library/Application Support/Google/Chrome/External Extensions/${extensionID}.json"
    if ! [[ -f "${prefFilePath}" ]]
    then
      echo "${prefContents}" > "${prefFilePath}"
    fi
  done

}

updateBootstrapReqs () {
  echo "updating bootstrap requriements . . . "
  if ! [ -d "${HOME}/.scry-shell" ]
  then
    git clone https://github.com/jstafford/scry-shell-base.git "${HOME}/.scry-shell"
  fi
  git -C "${HOME}/.scry-shell" pull
  source "${HOME}/.scry-shell/bootstrap_reqs.sh"
}

bootstrap () {
  echo "starting bootstrap . . . "
  updateBootstrapReqs
  bootstrapBrew
  bootstrapBrewBottles
  bootstrapBrewCasks
  bootstrapPythonWheels
  bootstrapNodeModules
  bootstrapAtomPackages
  bootstrapGoogleExtensions
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
