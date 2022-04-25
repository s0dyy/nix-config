{ config, pkgs, ... }:

{

  #                   __ _                       _   _             
  #   ___ ___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
  #  / __/ _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
  # | (_| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
  #  \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
  #                       |___/   

  imports = [ ./hardware-configuration.nix <home-manager/nixos> ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";

  networking.hostName = "nixos";
  time.timeZone = "Europe/Paris";

  networking.useDHCP = false;
  networking.interfaces.enp39s0.useDHCP = true;
  networking.interfaces.wlp41s0.useDHCP = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };
  services.xserver.layout = "fr";

  users.users.root.shell = pkgs.zsh;
  users.users.s0dyy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; 
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    rustup
    python310
    sbt
    bind
    adoptopenjdk-bin
    alacritty
    ansible
    bat
    chromium
    discord
    docker-compose
    dogdns
    exa
    fd
    figlet
    filezilla
    firefox
    fzf
    git
    gnome.gnome-tweaks
    gradle_7
    htop
    jetbrains.idea-community
    jq
    lsof
    maven
    mongodb
    mtr
    mysql80
    nmap
    nodejs
    orchis-theme
    p7zip
    pg_top
    pgpool
    postman
    psmisc
    redis
    s3cmd
    slack
    spotify
    starship
    teams
    tela-icon-theme
    terraform
    tmux
    transmission-gtk
    unrar
    unzip
    vim
    vlc
    vscode
    wget
    zoom-us
  ];

  environment.gnome.excludePackages = [ 
    pkgs.epiphany
    pkgs.evince
    pkgs.gnome-photos
    pkgs.gnome-tour
    pkgs.gnome.atomix
    pkgs.gnome.geary
    pkgs.gnome.gedit
    pkgs.gnome.gnome-characters
    pkgs.gnome.gnome-music
    pkgs.gnome.hitori
    pkgs.gnome.iagno
    pkgs.gnome.tali
    pkgs.gnome.totem
  ];

  services.openssh.enable = true;

  systemd.nspawn.exherbo.networkConfig.Private = false;
  systemd.nspawn.exherbo.execConfig = {
    PrivateUsers = "off";
  };
  systemd.nspawn.exherbo.filesConfig = {
     Bind = [ "/home/s0dyy/Documents/gitlab-exherbo" ];
  };
  systemd.nspawn.exherbo.enable = true;

  virtualisation.docker.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = [ pkgs.zsh ];

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_14;

  system.stateVersion = "21.11";

  #   _
  # | |__   ___  _ __ ___   ___       _ __ ___   __ _ _ __   __ _  __ _  ___ _ __
  # | '_ \ / _ \| '_ ` _ \ / _ \_____| '_ ` _ \ / _` | '_ \ / _` |/ _` |/ _ \ '__|
  # | | | | (_) | | | | | |  __/_____| | | | | | (_| | | | | (_| | (_| |  __/ |
  # |_| |_|\___/|_| |_| |_|\___|     |_| |_| |_|\__,_|_| |_|\__,_|\__, |\___|_|
  #                                                              |___/
  
  home-manager.users.s0dyy = { pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;

    programs.zsh = {
      enable = true;
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      autocd = true;
      localVariables = {
        EDITOR="vim";
        TERM="xterm-256color";
        ZSH_TMUX_AUTOSTART=true;
      };
      shellAliases = {
        ccd="cd $HOME/Documents/clevercloud-dev";
        ccp="cd $HOME/Documents/clevercloud-prod";
        doc="cd $HOME/Documents";
        dot="cd $HOME/Documents/github/dotfiles";
        dow="cd $HOME/Downloads";
        gh="cd $HOME/Documents/github";
        gl="cd $HOME/Documents/gitlab";
        glc="cd $HOME/Documents/gitlab-clevercloud";
        gle="cd $HOME/Documents/gitlab-exherbo";
        var="cd $HOME/Documents/various";
        ll1="exa -a1F --sort type --icons";
        ll1t="exa -a1TF --sort type --icons";
        ll="exa -lgF --sort type --time-style long-iso --icons";
        lla="exa -lagF --sort type --time-style long-iso --icons";
        llag="exa -lagF --git --sort type --time-style long-iso --icons";
        llat="exa -lagTF --sort type --time-style long-iso --icons";
        cat="bat";
        cc="clear";
        conf="sudo -e vim /etc/nixos/configuration.nix";
        exherbo="machinectl login exherbo";
        fd="fd -H -i -L";
        rebuild="sudo nixos-rebuild switch";
        rr="su -";
        zz="source $HOME/.zshrc";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "tmux" ];
      };
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      historyLimit = 10000;
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        line_break = {
          disabled = true;
        };
        username = {
          disabled = false;
          show_always = true;
          style_user = "red";
        };
        hostname = {
          disabled = false;
          ssh_only = false;
          style = "yellow";
        };
        directory = {
          style = "green";
        };
        git_branch = {
          style = "red";
        };
        cmd_duration = {
          min_time = 0;
          format = "took ";
        };
        time = {
          disabled = true;
        };
      };
    };

    programs.fzf = {
      enable = true;
    };

    programs.bat = {
      enable = true;
      config = {
        style = "plain";
        paging = "never";
        theme = "Dracula";
      };
    };
    
    programs.git = {
      enable = true;
      userName = "s0dyy";
      userEmail = "msorin@msorin.com";
    };
    
    programs.vscode = { 
      enable = true;
      extensions = with pkgs.vscode-extensions; [
 	pkief.material-icon-theme
        hashicorp.terraform
        matklad.rust-analyzer
        ms-azuretools.vscode-docker
        vscodevim.vim
        zhuangtongfa.material-theme
      ];
      userSettings = {
        "window.titleBarStyle" = "custom";
        "window.menuBarVisibility" = "toggle";
        "window.zoomLevel" = 0;
        "workbench.colorTheme" = "One Dark Pro";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.fontFamily" = "'JetBrainsMono Nerd Font'";
        "editor.fontSize" = 15;
        "editor.fontWeight" = 500;
        "editor.fontLigatures" = false;
        "editor.letterSpacing" = -0.5;
        "editor.minimap.renderCharacters" = false;
        "editor.minimap.size" = "proportional";
        "editor.minimap.scale" = 2;
        "editor.renderWhitespace" = "none";
        "editor.guides.indentation" = true;
        "editor.tabSize" = 2;
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Fond'";
        "terminal.integrated.fontSize" = 15;
        "terminal.integrated.fontWeight" = "400";
        "terminal.integrated.fontWeightBold" = "400";
        "terminal.integrated.letterSpacing" = 0.5;
      };
    };

  };

}

