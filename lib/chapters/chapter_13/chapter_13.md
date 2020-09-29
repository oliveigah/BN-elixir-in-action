# 13 - Running The System

## 13.1 - Commom Principles

- Regardless of the method you are going to use to run your system in production some principles always remain
  1 - Compile all module to `.beam `and `.app` files, that must exists somewhere in the release
  2 - Start the BEAM instance and setup load paths to include all locations of the previous step
  3 - Start all required OTP applications
- Mix has a great tool called `mix release` to help you with this task, checkout the docs
- You can interact with the production system via some pre defined scripts ans functions that can be released as well
- Releases are build under `_build/#{env}/rel/#{system's name}/bin/#{release's name}`
- To include stand alone files to the release, they must be inside the `priv` folder under the root can must be referenced on the code as `Application.app_dir(:app_name, "priv")`
- Env vars are under `_build/#{env}/rel/#{system's name}/bin/#{release's version}` inside the `sys.config` file
- Live upgrades are tricky and may require implement special functions to deal with

## 13.3 - Analyzing Behavior

- Debug distributed systems is hard
- The step by step debug is not frequentlly used in Erlang (although it exists)
- Its impossible to do classical debugging on high concurrency systems
- The most commom debug techinique is loggins and tracing
- BEAM ships with the `:logger` module that is used by OTP modules provide great amount of information
- OTP compliant modules provides full trace and logging by default
- Whenever the trace is not enough `inspect/1` and `IEX.pry/1` may help
- You can interact with the production system, via IEX
- Sometimes you need to ship kind of non system related dependencies, such as observer. This is done by `extra_applications:` tag inside mix.exs
