# Configurable Nix Flakes
Currently nix flakes do not inherently support specifying configurable
options for the outputs of a flake. This is an attempt to work around
this by using the NixOS module system to declare and later specifying
options.

**This is very much work in progress**

This flake provides one output `lib` which currently contains two nix functions:

## `lib.configurableFlake`: `inputs -> {options, config} -> outputBuilder -> outputs`
This function takes the flake inputs, then an attrset of options
declarations (`options`) and definitions (`config`) and then a
function that gets the evaluated config as well as the inputs and
returns the output of the flake.

## `lib.withSystems`: `inputs -> [<system>] -> outputBuilder -> outputs`
This is a shorthand only taking the inputs, a list of supported systems and an outputBuilder as above.
`config` is automatically filled with `systems` being a list of the supplied systems.

## `outputs.withConfig`: `config -> outputs`
Flakes that are constructed with the above functions will have a function `withConfig` that can be called
to derive a flake with different configurations options. This makes using an existing flake with
a different configuration as easy as:

```nix
{
  description =
    "Example of using a flake with a different configuration";
  inputs.someConfigurableFlake.url = "someurl";
  outputs = {self, someConfigurableFlake}:
    someConfigurableFlake.withConfig {
      supportFoo = true;
    };
}
```
