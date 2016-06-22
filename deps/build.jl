using Compat

sources = [
  "im2col.cpp",
  "maxpooling2d.cpp",
  "softmax.cpp",
  "window2d.cpp",
  "window.cpp"]

compiler = "g++"

function build_windows()
  flags    = ["-Wall", "-O3", "-shared", "-march=native"]
  libname = "libmerlin.dll"
  cmd = `$compiler $flags -o $libname $sources`
  println("Running $cmd")
  run(cmd)
end

@compat if is_apple()
  flags    = ["-fPIC", "-Wall", "-O3", "-shared", "-march=native"]
  libname = "libmerlin.so"
  cmd = `$compiler $flags -o $libname $sources`
  println("Running $cmd")
  run(cmd)
elseif is_linux()
  flags    = ["-fopenmp", "-fPIC", "-Wall", "-O3", "-shared", "-march=native"]
  libname = "libmerlin.so"
  cmd = `$compiler $flags -o $libname $sources`
  println("Running $cmd")
  run(cmd)
else
  ()
end
