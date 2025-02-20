{ shells
, androidenv
, stdenv
, darwin
, jdk17
, mktemp
, kotlin
, gradle
, lib
, ...
}:

let
  inherit (stdenv) isDarwin;
  inherit (darwin.apple_sdk) frameworks;
  inherit (androidComposition) androidsdk;
  android = {
    platforms = [
      "27"
      "31"
      "33"
      "34"
      "35"
    ];
    systemImageTypes = [
      "google_apis"
      "google_apis_playstore"
      "default"
    ];
    abis = [ "arm64-v8a" ];
  };

  sdkArgs = {
    inherit (android) systemImageTypes;
    platformVersions = android.platforms;
    abiVersions = android.abis;
    buildToolsVersions = [
      "30.0.3"
      "35.0.0"
    ];
    includeSystemImages = false;
    includeEmulator = false;

    # Accepting more licenses declaratively:
    extraLicenses = [
      # These aren't, but are useful for more uncommon setups.
      "android-sdk-preview-license"
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };

  androidHome = "${androidComposition.androidsdk}/libexec/android-sdk";
  androidComposition = androidenv.composeAndroidPackages sdkArgs;
  #androidEmulator = androidenv.emulateApp {
  #  name = "libxmtp-integration-tests";
  #  platformVersion = "31";
  #  abiVersion = "arm64-v8a";
  #  systemImageType = "default";
  #  # androidEmulatorFlags = "-gpu swiftshader_indirect -accel hvf -no-snapshot-load";
  #  configOptions = {
  #    "hw.ramSize" = "2048"; # Allocate 2GB of RAM, increase if needed
  #    "hw.keyboard" = "yes";
  #  };
  #  sdkExtraArgs = sdkArgs;
  #};
  mkShell =
    this:
    shells.combineShell {
      otherShells = with shells;
        [
          mkLinters
          mkGrpc
        ];
      extraInputs = this;
    };
in
mkShell {
  # inherit shellHook;
  ANDROID_HOME = "${androidHome}";
  ANDROID_SDK_ROOT = "${androidHome}";
  ANDROID_NDK_ROOT = "${androidHome}/ndk-bundle";
  # TEST_EMU = androidEmulator;
  JAVA_HOME = jdk17.home;
  packages = [
    androidsdk
    jdk17
  ];
  nativeBuildInputs = [
    androidsdk
    jdk17
  ];
  buildInputs =
    [
      mktemp
      kotlin
      gradle
    ]
    ++ lib.optionals isDarwin [
      frameworks.CoreServices
      darwin.cctools
    ];
}
