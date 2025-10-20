{ inputs }:
{
  additions =
    final: prev:
    import ../pkgs {
      pkgs = final;
      inherit inputs;
    };
}
