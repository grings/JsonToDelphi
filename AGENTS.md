# JsonToDelphi project notes

Also consider the global notes in `C:\Desenvolvimento\AGENTS.md`.

## Delphi build environment

- Default Delphi build: Delphi 12 Athens / BDS 23.0 / CompilerVersion 36 / VER360.
- Use Delphi 13 Florence / BDS 37.0 / CompilerVersion 37 / VER370 only for Android builds or when explicitly requested.
- For command-line Win32 builds, use Delphi 12 `rsvars.bat` plus the .NET
  Framework MSBuild by absolute path, because `msbuild` might not be in PATH.
- Validated PowerShell command for the uniGUI project:

```powershell
& cmd.exe /c 'call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat" && "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" unigui\JsonToDelphi.dproj /t:Build /p:Config=Release /p:Platform=Win32'
```

- Validated PowerShell command for the FMX/class project:

```powershell
& cmd.exe /c 'call "C:\Program Files (x86)\Embarcadero\Studio\23.0\bin\rsvars.bat" && "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe" fmx\JsonToDelphiClass.dproj /t:Build /p:Config=Release /p:Platform=Win32'
```

- For `Debug Win32`, use the same command with `/p:Config=Debug`.
- In PowerShell, prefer the single-quoted outer `cmd.exe /c` form above. Do not
  escape quotes with backslashes inside a double-quoted PowerShell string,
  because paths containing `(x86)` can be parsed incorrectly before reaching
  `cmd`.
- This uniGUI web project is hosted/published as an ISAPI DLL on IIS. For publication builds, keep `UNIGUI_DLL` enabled in `unigui\JsonToDelphi.dpr` and compile the DLL output.
- For local browser testing with `http://localhost`, temporarily compile as `UNIGUI_VCL`/EXE, then restore `UNIGUI_DLL` before committing or publishing. The committed/default source state should keep `UNIGUI_DLL` enabled.
- Preserve `.dproj` changes when they occur; review them normally with the rest of the modified Delphi files.
- Keep created or modified Delphi files (`.pas`, `.dfm`, `.dpr`, `.dproj`, `.inc`) encoded as UTF-8 with BOM and CRLF line endings.
