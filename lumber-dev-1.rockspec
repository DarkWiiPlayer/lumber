package = "lumber"
version = "dev-1"
source = {
   url = "git+https://github.com/darkwiiplayer/lumber"
}
description = {
   homepage = "https://github.com/darkwiiplayer/lumber",
   license = "Unlicense"
}
dependencies = {
   "lua ~> 5, >= 5.1"
}
build = {
   type = "builtin",
   modules = {
      ["lumber.format.file"] = "lumber/format/file.lua",
      ["lumber.format.plain"] = "lumber/format/plain.lua",
      ["lumber.format.term"] = "lumber/format/term.lua",
      ["lumber.init"] = "lumber/init.lua"
   }
}
