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

# easy setup to get your environment bootstrapped, and scry-shell added to
# your bash_profile

source "./bootstrap"

if [ -f "${HOME}/.bash_profile" ]
then
  file=$(<"${HOME}/.bash_profile")
  IFS=$'\n' read -rd '' -a $fileLines <<<"$file"
  shebang=${fileLines[0]}
  unset "fileLines[0]"
  file=$(printf '%s\n' "${fileLines[@]}")
else
  shebang="#!/bin/bash"
fi

scrySource="\nsource \"${HOME}/.scry-shell/scry-shell.sh\"\n"

boostrap

echo "${shebang}" > "${HOME}/.bash_profile"
echo "${scrySource}" >> "${HOME}/.bash_profile"
if [ -n "${file}" ]
then
  echo "${file}" >> "${HOME}/.bash_profile"
fi
