@ECHO OFF
ECHO "Symlink for %cd%\.bashrc to %USERPROFILE%\.bashrc"

IF EXIST ["%USERPROFILE%\.bashrc"] (
    del ["%USERPROFILE%\.bashrc"]
)

mklink /H "%USERPROFILE%\.bashrc" "%cd%\.bashrc"


ECHO "Symlink for %cd%\.gitconfig to %USERPROFILE%\.gitconfig"

IF EXIST ["%USERPROFILE%\.gitconfig"] (
    del ["%USERPROFILE%\.gitconfig"]
)

mklink /H "%USERPROFILE%\.gitconfig" "%cd%\.gitconfig"
PAUSE