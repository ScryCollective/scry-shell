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
#   TOOLS FOR WORKING WITH MULTIPLE GIT/NODE PROJECTS
#   ---------------------------------------

# if you have a bunch of git projects cloned as sibling folders, start at the
# parent, and do things like:
# deepgit status
# deepgit fetch
# deepgit pull
# deepgit add .
# deepgit commit -m "cross project cleanup to fix excess whitespace vulnerablity"
# deepgit push
deepgit () {
  for item in *
  do
    # only directories are examined
    if [[ -d "${item}" ]]
    then
      # if they have a .git sub directory, then they are assumed to be a git repo
      if [[ -d "${item}/.git" ]]
      then
        echo "————————————————————————————————————————"
        echo "$(pwd)/${item}"
        git -C "${item}" "$@"
      # otherwise recurse into the directory, unless the name begins with micro
      elif [[ "${item:0:1}" != "µ" ]]
      then
        pushd "${item}" > /dev/null
        deepgit "$@"
        popd > /dev/null
      fi
    fi
  done
}

# if you have a bunch of node projects in sibling folders, or even nested within
# each other, start at a containing folder, and do things link:
# deepyarn outdated
# deepyarn upgrade
# deepyarn add react
deepyarn () {
  for item in *
  do
    # only directories are examined
    if [[ -d "${item}" ]]
    then
      # if they have a package.json file directory, then they are assumed to be a node project
      if [[ -f "${item}/package.json" ]]
      then
        echo "————————————————————————————————————————"
        echo "$(pwd)/${item}"
        pushd "${item}" > /dev/null
        yarn "$@"
        popd > /dev/null
    # otherwise recurse into the directory, unless the name is node_modules
      elif [[ "${item}" != "node_modules" ]]
      then
        pushd "${item}" > /dev/null
        deepyarn "$@"
        popd > /dev/null
      fi
    fi
  done
}
