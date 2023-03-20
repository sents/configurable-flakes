{lib}: let
  evalConfig = options: config:
    let
      mergedConfig = lib.evalModules {
        modules = [
          { inherit options; }
          { inherit config; }
        ];
      };
    in mergedConfig;
  configurableFlake = inputs:
    {
      options
    , config ? { }
    }: outputBuilder:
      let mergedConfig = evalConfig options config;
          withConfig = newConfig: configurableFlake {
            config = newConfig;
            inherit options inputs;} outputBuilder;
      in
        (outputBuilder (inputs // {config = mergedConfig.config;})) //
        { config = mergedConfig; inherit options withConfig;};
  withSystems = inputs: systems:
    let options = {
          systems = lib.mkOption {
            type = with lib.types; listOf (enum utils.allSystems);
            default = systems;
          };
        };
        config = {
          inherit systems;
        };
    in
      configurableFlake inputs {
        inherit options config;
      };
in
  {
    inherit configurableFlake;
    inherit withSystems;
  }
