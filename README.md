# dopa / nodopa

`dopa` と入力すると指定した曲を再生し、`nodopa` と入力すると止めるためのWindows用コマンドです。

## できること

- `dopa` で登録済みの音楽ファイルを再生する
- `nodopa` で再生中の曲を停止する
- 音楽ファイル未設定の場合は「あさのひかりの中で」のYouTube検索を開く

## 必要なもの

- Windows
- PowerShell
- 再生したい音楽ファイル

対応しやすい音楽ファイル形式:

```text
.mp3
.m4a
.wav
.flac
```

一番おすすめは `.mp3` です。

## インストール

PowerShellを開いて、次のコマンドを実行します。

```powershell
powershell -ExecutionPolicy Bypass -File ".\install-dopa.ps1"
```

`install-dopa.ps1` があるフォルダで実行してください。

実行後、CMDまたはPowerShellを一度閉じて、新しく開き直してください。

## 曲を指定する

次のコマンドで、`dopa` で再生する曲を指定します。

```powershell
powershell -ExecutionPolicy Bypass -File ".\set-dopa-track.ps1" "C:\path\to\song.mp3"
```

別の曲にしたい場合は、最後の音楽ファイルのパスを変更してください。

例:

```powershell
powershell -ExecutionPolicy Bypass -File ".\set-dopa-track.ps1" "$env:USERPROFILE\Music\song.mp3"
```

音楽ファイルをPowerShellへドラッグ&ドロップすると、ファイルのフルパスを簡単に入力できます。

## 使い方

新しいCMDまたはPowerShellを開いて、次のように入力します。

再生:

```cmd
dopa
```

停止:

```cmd
nodopa
```

## インストール確認

CMDで次のコマンドを実行します。

```cmd
where dopa
where nodopa
```

次のようなパスが表示されれば成功です。

```text
%LOCALAPPDATA%\Programs\dopa-bin\dopa.cmd
%LOCALAPPDATA%\Programs\dopa-bin\nodopa.cmd
```

## うまく動かないとき

### `dopa` が認識されない

インストール後に開きっぱなしだったCMDやPowerShellには、PATH設定が反映されていないことがあります。

CMDまたはPowerShellを閉じて、新しく開いてからもう一度試してください。

すぐ試したい場合は、CMDで直接実行できます。

```cmd
"%LOCALAPPDATA%\Programs\dopa-bin\dopa.cmd"
```

停止は次のコマンドです。

```cmd
"%LOCALAPPDATA%\Programs\dopa-bin\nodopa.cmd"
```

### 曲が流れない

音楽ファイルの場所が正しく登録されているか確認してください。

登録し直す場合:

```powershell
powershell -ExecutionPolicy Bypass -File ".\set-dopa-track.ps1" "C:\path\to\song.mp3"
```

また、Windowsの音量ミキサーで `Windows PowerShell` がミュートになっていないか確認してください。

### `nodopa` で止まらない

最新版では、`nodopa` が再生用のPowerShellプロセスを探して停止します。

念のため、もう一度インストールを実行してください。

```powershell
powershell -ExecutionPolicy Bypass -File ".\install-dopa.ps1"
```

そのあと、新しいCMDまたはPowerShellで試してください。

```cmd
dopa
nodopa
```

## ファイル構成

```text
dopa.cmd             再生コマンド
nodopa.cmd           停止コマンド
dopa-player.ps1      音楽を再生する内部スクリプト
install-dopa.ps1     dopa / nodopa を使えるようにするインストーラー
set-dopa-track.ps1   再生する音楽ファイルを指定する設定スクリプト
README.md            この説明書
```

## 設定の保存場所

指定した音楽ファイルのパスは、次のファイルに保存されます。

```text
%USERPROFILE%\.dopa-track.txt
```

このファイルには、再生したい音楽ファイルのフルパスが1行だけ入っています。
