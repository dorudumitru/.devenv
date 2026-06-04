local overseer = require("overseer")

local function is_windows()
  return vim.uv.os_uname().sysname:match("Windows") ~= nil
end

local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

local function executable_exists(cmd)
  return vim.fn.executable(cmd) == 1
end

local function project_root()
  return vim.fs.root(0, {
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "mvnw",
    "gradlew",
    ".git",
  }) or vim.fn.getcwd()
end

local function has_maven(root)
  return file_exists(root .. "/pom.xml")
end

local function has_gradle(root)
  return file_exists(root .. "/build.gradle") or file_exists(root .. "/build.gradle.kts")
end

local function maven_cmd(root)
  if is_windows() then
    if file_exists(root .. "/mvnw.cmd") then
      return "mvnw.cmd"
    end
  else
    if file_exists(root .. "/mvnw") then
      return "./mvnw"
    end
  end

  return "mvn"
end

local function gradle_cmd(root)
  if is_windows() then
    if file_exists(root .. "/gradlew.bat") then
      return "gradlew.bat"
    end
  else
    if file_exists(root .. "/gradlew") then
      return "./gradlew"
    end
  end

  return "gradle"
end

local function split_words(value)
  local words = {}
  for word in tostring(value or ""):gmatch("%S+") do
    table.insert(words, word)
  end
  return words
end

local function components()
  return {
    { "on_output_quickfix", open = false },
    "default",
  }
end

local function make_task(name, cmd, args, cwd, tags)
  return {
    name = name,
    tags = tags or {},
    builder = function()
      return {
        cmd = cmd,
        args = args,
        cwd = cwd,
        components = components(),
      }
    end,
  }
end

local function make_param_task(name, cmd, cwd, param_name, desc)
  return {
    name = name,
    params = {
      [param_name] = {
        type = "string",
        desc = desc,
        order = 1,
      },
    },
    builder = function(params)
      local args = split_words(params[param_name])

      return {
        name = name .. ": " .. table.concat(args, " "),
        cmd = cmd,
        args = args,
        cwd = cwd,
        components = components(),
      }
    end,
  }
end

return {
  condition = {
    callback = function()
      local root = project_root()
      return has_maven(root) or has_gradle(root)
    end,
  },

  generator = function(_, callback)
    local root = project_root()
    local tasks = {}

    if has_maven(root) then
      local mvn = maven_cmd(root)

      if executable_exists(mvn) then
        vim.list_extend(tasks, {
          make_task("Maven: Spring Boot run", mvn, { "spring-boot:run" }, root, { overseer.TAG.RUN }),

          make_task("Maven: test", mvn, { "test" }, root, { overseer.TAG.TEST }),
          make_task("Maven: verify", mvn, { "verify" }, root, { overseer.TAG.TEST }),

          make_task("Maven: package", mvn, { "package" }, root, { overseer.TAG.BUILD }),
          make_task("Maven: clean package", mvn, { "clean", "package" }, root, { overseer.TAG.BUILD }),

          make_task("Maven: Spring Boot build image", mvn, { "spring-boot:build-image" }, root, { overseer.TAG.BUILD }),

          make_task(
            "Maven: native package",
            mvn,
            { "clean", "-Pnative", "package", "-DskipTests" },
            root,
            { overseer.TAG.BUILD }
          ),

          make_param_task(
            "Maven: run goal(s)",
            mvn,
            root,
            "goals",
            "Example: clean install -DskipTests or spring-boot:run -Dspring-boot.run.profiles=dev"
          ),
        })
      end
    end

    if has_gradle(root) then
      local gradle = gradle_cmd(root)

      if executable_exists(gradle) then
        vim.list_extend(tasks, {
          make_task("Gradle: Spring Boot run", gradle, { "bootRun" }, root, { overseer.TAG.RUN }),

          make_task("Gradle: test", gradle, { "test" }, root, { overseer.TAG.TEST }),
          make_task("Gradle: check", gradle, { "check" }, root, { overseer.TAG.TEST }),

          make_task("Gradle: build", gradle, { "build" }, root, { overseer.TAG.BUILD }),
          make_task("Gradle: clean build", gradle, { "clean", "build" }, root, { overseer.TAG.BUILD }),

          make_task("Gradle: Spring Boot build image", gradle, { "bootBuildImage" }, root, { overseer.TAG.BUILD }),

          make_task("Gradle: native compile", gradle, { "nativeCompile", "-x", "test" }, root, { overseer.TAG.BUILD }),

          make_param_task(
            "Gradle: run task(s)",
            gradle,
            root,
            "tasks",
            "Example: bootRun, clean build, nativeCompile -x test, or test --tests com.example.MyTest"
          ),
        })
      end
    end

    callback(tasks)
  end,
}
