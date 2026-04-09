{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, pkg-config
, fcitx5
, qtbase
, qtwayland
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
    pname = "im-emoji-picker";
    version = "556a369";

    src = fetchFromGitHub {
        owner = "GaZaTu";
        repo = "im-emoji-picker";
        rev = version;
        hash = "sha256-6yXPbbClsyMuzKIiU3IHg+UR0UtdzMFj3NzpV/Hzz6E=";
    };

    nativeBuildInputs = [
        cmake
        ninja
        pkg-config
        wrapQtAppsHook
    ];

    buildInputs = [
        fcitx5
        qtbase
        qtwayland
    ];

    # Make Qt plugins available at runtime for fcitx5
    propagatedBuildInputs = [ qtwayland ];

    strictDeps = true;
    cmakeBuildType = "Release";
    dontWrapQtApps = true;

    # Export Qt plugin path for fcitx5-with-addons wrapper
    passthru.qtPluginPath = "${qtwayland.bin}/lib/qt-${qtbase.version}/plugins";

    cmakeFlags = [
        "-DONLY_FCITX5=ON"
        "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}"
    ];

    postPatch = ''
        substituteInPlace CMakeLists.txt \
            --replace-fail 'set(CMAKE_INSTALL_PREFIX /usr)' "" \
            --replace-fail \
                'LIBRARY DESTINATION ''${CMAKE_INSTALL_PREFIX}/lib64/fcitx5' \
                'LIBRARY DESTINATION ''${CMAKE_INSTALL_PREFIX}/lib/fcitx5' \
            --replace-fail \
                'install(CODE "execute_process(COMMAND touch /usr/share/icons/hicolor)")' \
                ""
    '';

    meta = with lib; {
        description = "Emoji picker input method for Fcitx5";
        homepage = "https://github.com/GaZaTu/im-emoji-picker";
        license = licenses.mit;
        platforms = platforms.linux;
    };
}
