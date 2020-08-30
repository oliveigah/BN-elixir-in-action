# 11- Working With Components

## 11.1 - OTP Applications

- It is a way to keep together multiple modules and resources as a unique executable system
- It is defined by the application resource file, writen in pure erlang
- Mix tool provides shortcuts to define it inside mix.exs file
- OTP application are not equivalente to Mix projects, the former is a runtime construct and the later a compile-time construct, the OTP application is derived from the Mix project
- The callback module is the main module that starts the application
- Library applications do not have a callback module

## 11.2 - Dependencies
- Dependencies must be specified in mix.exs file
- Dependencies are specified as tuples like: `{:dependency_name, "version requiriments"}`
- Version synstax can be found on hexdocs documentation
- After specified you must run `mix deps.get` to acquire the dependencies from a remote repository
- This command will generate the mix.lock file which contains the references to each dependency
- mix.lock file is used by the `mix compile` command

## 11.3 - Web Server
- Web servers can be implemented from scratch but it is pointless. Instead you coul use some battle tested libraries such ass cowboy and plug. Or even a really powerfull framework like phoenix
- The integration of the HTTP server wit the system is flawless. The "Phoenix is not your application" approach correlates strongly with the best architecturals practices of the modern software development

## 11.4 - Configuration
- Application envioronment is a key/value struct that holds data that is accessible from any module
- The definition of this struct is done by the config.exs file, usually locate inside the config folder
- Inside it you can write elixir code to define the variables
- The configuration can vary accordingly to the environment, by default: prod, dev and test
- Config scripts are evaluated before the compilation, so you cant use any custom module
