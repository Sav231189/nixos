# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║  NixOS Flake Configuration                                                   ║
# ╠══════════════════════════════════════════════════════════════════════════════╣
# ║  Это главный файл конфигурации NixOS с использованием Flakes.                ║
# ║                                                                              ║
# ║  ЧТО ТАКОЕ FLAKE?                                                            ║
# ║  Flake — это современный способ управления зависимостями в Nix.              ║
# ║  Он гарантирует воспроизводимость: одинаковый результат на любой машине.     ║
# ║                                                                              ║
# ║  СТРУКТУРА:                                                                  ║
# ║  • inputs  — внешние зависимости (nixpkgs, home-manager, etc.)               ║
# ║  • outputs — что мы экспортируем (конфигурации систем)                       ║
# ║                                                                              ║
# ║  КАК ИСПОЛЬЗОВАТЬ:                                                           ║
# ║  1. nixos-rebuild switch --flake .#matebook  — применить конфигурацию        ║
# ║  2. nix flake update                         — обновить зависимости          ║
# ║  3. nix flake check                          — проверить синтаксис           ║
# ╚══════════════════════════════════════════════════════════════════════════════╝
{
  description = "NixOS configuration for Huawei MateBook X Pro";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Impermanence
    impermanence.url = "github:nix-community/impermanence";

    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, impermanence, hyprland, ... }@inputs:
  let
    system = "x86_64-linux";
    
    # Custom lib with helper functions
    lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      matebook = lib.nixosSystem {
        inherit system;
        
        specialArgs = { inherit inputs; };
        
        modules = [
          # Host configuration
          ./hosts/matebook
          
          # Impermanence
          impermanence.nixosModules.impermanence
          
          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.aleksandr = import ./home/aleksandr;
            };
          }
        ];
      };
    };
  };
}
