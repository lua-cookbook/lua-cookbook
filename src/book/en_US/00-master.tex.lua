#! /usr/bin/env lua

pcall(require, 'luarocks.require')
local lfs = require 'lfs'

local function find_all_files(path, regexp, dest, mode)
  dest = dest or {}
  mode = mode or false

  assert(mode ~= "directory")

  for filename in lfs.dir(path) do
    if filename ~= "." and filename ~= ".." then
      local filepath = path .. "/" .. filename
      local attr = lfs.attributes(filepath)
      if attr.mode == "directory" then
        find_all_files(filepath, regexp, dest)
      elseif not mode or attr.mode == mode then
        if filename:find(regexp) then
          dest[#dest + 1] = filepath
        end
      end
    end
  end

  return dest
end

local all_files = find_all_files(".", ".*%.tex$")
table.sort(all_files)

io.stdout:write [[
\documentclass[11pt,a4paper,twoside,openany]{book}

\usepackage[english]{babel}
\usepackage{microtype}
\usepackage{makeidx}
\usepackage{hyperref}
\usepackage{graphicx}

\usepackage{lua-cookbook}

\begin{document}

\title{Lua Cookbook}
\author{Lua Cookbook Authors}
\date{2011}

\frontmatter
\tableofcontents

\mainmatter

]]

for i = 1, #all_files do
  io.stdout:write ([[
\include{]], all_files[i]:gsub("(%.tex)$", ""), [[}
]])
end

io.stdout:write [[
\backmatter
\printindex

\end{document}
]]
