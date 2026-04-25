{ config, pkgs, lib, ... }:

let
  cfg = config.deepwoods.apps.minecraft;
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/SonormaY/deepwoods/refs/heads/main/modules/minecraft/mc_fabric_pack/pack.toml";
    packHash = lib.fakeHash;
  };
in {
  options.deepwoods.apps.minecraft = {
    enable = lib.mkEnableOption "Fabric Minecraft Server";
  };

  config = lib.mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers.fabric = {
        enable = true;

        package = pkgs.fabricServers.fabric-26_1_2.override {
          loaderVersion = "0.19.2";
          jre_headless = pkgs.jdk25_headless;
        };

        jvmOpts = "-Xms4096M -Xmx4096M -XX:+UnlockDiagnosticVMOptions -XX:+UnlockExperimentalVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+DoEscapeAnalysis -XX:+EagerJVMCI -XX:+EliminateLocks -XX:+EnableJVMCI -XX:+EnableJVMCIProduct -XX:+OmitStackTraceInFastThrow -XX:+OptimizeStringConcat -XX:+ParallelRefProcEnabled -XX:+PerfDisableSharedMem -XX:+RangeCheckElimination -XX:+RewriteBytecodes -XX:+RewriteFrequentPairs -XX:+SegmentedCodeCache -XX:+TrustFinalNonStaticFields -XX:+UseAES -XX:+UseAESIntrinsics -XX:+UseCodeCacheFlushing -XX:+UseCompressedOops -XX:+UseCriticalJavaThreadPriority -XX:+UseCriticalJavaThreadPriority -XX:+UseFastJNIAccessors -XX:+UseFastUnorderedTimeStamps -XX:+UseFastUnorderedTimeStamps -XX:+UseFMA -XX:+UseFPUForSpilling -XX:+UseG1GC -XX:+UseInlineCaches -XX:+UseJVMCICompiler -XX:+UseLargePages -XX:+UseLoopPredicate -XX:+UseNUMA -XX:+UseStringDeduplication -XX:+UseThreadPriorities -XX:+UseTransparentHugePages -XX:+UseTransparentHugePages -XX:+UseVectorCmov -XX:+UseVectorCmov -XX:+UseXMMForArrayCopy -XX:AllocatePrefetchStyle=3 -XX:ConcGCThreads=2 -XX:-DontCompileHugeMethods -XX:G1HeapRegionSize=8M -XX:G1HeapWastePercent=5 -XX:G1MaxNewSizePercent=40 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1NewSizePercent=30 -XX:G1ReservePercent=20 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:InitiatingHeapOccupancyPercent=15 -XX:MaxGCPauseMillis=200 -XX:MaxNodeLimit=240000 -XX:MaxTenuringThreshold=1 -XX:NmethodSweepActivity=1 -XX:NodeLimitFudgeFactor=8000 -XX:NonNMethodCodeHeapSize=12M -XX:NonProfiledCodeHeapSize=194M -XX:ParallelGCThreads=8 -XX:ProfiledCodeHeapSize=194M -XX:ReservedCodeCacheSize=400M -XX:SurvivorRatio=32 -XX:ThreadPriorityPolicy=1 -Xlog:async -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/urandom -Djline.terminal=jline.UnsupportedTerminal -Dlog4j2.formatMsgNoLookups=true -Dterminal.ansi=true -Dterminal.jline=false -Djvmci.Compiler=graal -Daikars.new.flags=true -Dusing.aikars.flags=https://mcflags.emc.gs -Dgraal.CompilerConfiguration=enterprise -Dgraal.DetectInvertedLoopsAsCounted=true -Dgraal.EnterprisePartialUnroll=true -Dgraal.InfeasiblePathCorrelation=true -Dgraal.LoopInversion=true -Dgraal.OptDuplication=true -Dgraal.SpeculativeGuardMovement=true -Dgraal.StripMineNonCountedLoops=true -Dgraal.TuneInlinerExploration=1 -Dgraal.TuneInlinerExploration=1 -Dgraal.UsePriorityInlining=true -Dgraal.Vectorization=true -Dgraal.VectorizeHashes=true -Dgraal.VectorizeSIMD=true --add-modules=jdk.incubator.vector --nogui";

        serverProperties = {
          server-port = 25565;
          difficulty = 3;
          gamemode = "survival";
          motd = "Welcome to the Deepwoods!";
          white-list = true;
        };

        whitelist = {
          sonormay = "724e39c4-9e55-40a8-9252-0a9170b4cf19";
        };

        symlinks = {
          "mods" = "${modpack}/mods";
        };

        # files = {
        #   "config" = "${modpack}/config";
        # };
      };
    };
  };
}
