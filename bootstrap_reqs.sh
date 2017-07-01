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

# command line applications
export requiredBottles=(
  "awscli"
  "node"
  "openssl"
  "p7zip"
  "packer"
  "pkg-config"
  "python"
  "shellcheck"
  "unrar"
  "watchman"
  "wget"
  "xz"
  "yarn"
)

# gui applications
export requiredCasks=(
  "adobe-reader"
  "atom"
  "caffeine"
  "firefox"
  "google-chrome"
  "google-drive"
  "inkscape"
  "java"
  "macdown"
  "openoffice"
  "paintbrush"
  "quickbooks"
  "rowanj-gitx"
  "spectacle"
  "textwrangler"
  "xquartz"
)

# python libraries
export requiredWheels=(
  "appdirs"
  "packaging"
  "pyparsing"
  "six"
  "sqlparse"
)

# node libraries
export requiredModules=(
  "babel-cli@^6.24.1"
  "babel-eslint@^7.2.3"
  "babel-preset-flow@^6.23.0"
  "create-react-app@^1.3.0"
  "eslint@^3.19.0"
  "eslint-config-react-app@^0.6.2"
  "eslint-plugin-babel@^4.1.1"
  "eslint-plugin-flowtype@^2.33.0"
  "eslint-plugin-import@^2.2.0"
  "eslint-plugin-jsx-a11y@^4.0.0"
  "eslint-plugin-markdown@^1.0.0-beta.6"
  "eslint-plugin-node@^4.2.2"
  "eslint-plugin-promise@^3.5.0"
  "eslint-plugin-react@^6.10.3"
  "flow-bin@>=0.46.0"
  "node-gyp@^3.6.1"
)

# atom extensions
export requiredPackages=(
  "atom-beautify"
  "busy-signal"
  "git-control"
  "git-plus"
  "git-time-machine"
  "intentions"
  "linter"
  "linter-eslint"
  "linter-flow"
  "linter-jsonlint"
  "linter-shellcheck"
  "linter-stylelint"
  "linter-ui-default"
  "react"
  "script"
  "sort-lines"
  "split-diff"
)

# google chrome extensions
export requiredExtensions=(
  "lmjegmlicamnimmfhcmpkclmigmmcbeh" # Application Launcher for Drive
  "aohghmighlieiainnegkcijnfilokake" # Google Docs
  "ghbmnnjooekpmoecnnnilnnbdlolhkhi" # Google Docs Offline
  "nckgahadagoaajjgafhacjanaoiihapd" # Google Hangouts
  "felcaaldnbdncclmgdcncolpebgiejap" # Google Sheets
  "aapocclcgogkmnckokdopfmhonfmgoek" # Google Slides
  "hgldghadipiblonfkkicmgcbbijnpeog" # Immutable.js Object Formatter
  "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
  "lmhkpmbekcpmknklioeibfkpmmfibljd" # Redux DevTools
)
