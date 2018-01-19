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
#   UPGRADE DEVELOPMENT ENVIRONMENT
#   ---------------------------------------

#   upgrade: Upgrade brew itself, and all installed bottles and casks,
#            then upgrade all python wheels installed with pip, all
#            globally installed node modules, and finally all atom packages.
#   We wait to run cleanup until the next time upgrade is run, so that in
#      the unfortunate event there is a problem with one of the installs,
#      it is easier to revert back to the previous version.
upgrade () {
  echo "cleaning up from previous upgrades . . ."
  echo "starting brew cleanup . . ."
  brew cleanup
  echo "starting brew cask cleanup . . ."
  brew cask cleanup
  echo "starting brew update . . . "
  brew update
  echo "starting brew upgrade . . . "
  brew upgrade
  echo "starting brew cask upgrade . . . "
  brew cask outdated --quiet | xargs brew cask reinstall
  echo "starting brew doctor . . . "
  brew doctor
  echo "starting python wheel upgrade . . . "
  pip list --format legacy --outdated | cut -d ' ' -f1 | xargs -n1 pip install --upgrade
# the following strategy doesn't work for upgrading global npm libraries, because
# many of the global npm modules that we depend on have peer dependencies that
# are not yet depending on the latest versions of their peers. Upgrading the peer
# dependencies to latest breaks the main module (which was the reason we had the
# peer dependency in the first place)
#  npm outdated -g | tail -n +2 | cut -d ' ' -f1 | xargs -n1 npm install -g;
# By changing bootstrap to install with version specifications (as it now does),
#  then the simple npm upgrade works as expected.
  echo "starting global node module upgrade . . . "
  npm upgrade -g
  echo "starting atom package upgrade . . . "
  apm upgrade --no-confirm
}
