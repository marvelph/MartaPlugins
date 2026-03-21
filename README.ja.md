# MartaPlugins
[日本語](README.ja.md) | [English](README.md)

[Marta](https://marta.sh) のプラグインです。
## movement.lua
**Plugin ID:** `org.programmershigh.movement`
### Move to Next Selection
**Action ID:** `move.next.selection`

次に選択されている項目までカーソルを移動します。
### Move to Previous Selection
**Action ID:** `move.previous.selection`

前に選択されている項目までカーソルを移動します。
## navigation.lua
**Plugin ID:** `org.programmershigh.navigation`
### Change Current Pane to Left
**Action ID:** `change.current.pane.left`

左側のパネルにフォーカスを移動します。
### Change Current Pane to Right
**Action ID:** `change.current.pane.right`

右側のパネルにフォーカスを移動します。
### Clone Current Folder to Active Pane
**Action ID:** `clone.active`

フォーカスされているパネルのディレクトリをフォーカスされていないパネルのディレクトリに揃えます。
### Clone Current Folder to Inactive Pane
**Action ID:** `clone.inactive`

フォーカスされていないパネルのディレクトリをフォーカスされているパネルのディレクトリに揃えます。
### Go to Root
**Action ID:** `go.root`

ルートディレクトリに移動します。
### Go to Home
**Action ID:** `go.home`

ホームディレクトリに移動します。
## rename.lua
**Plugin ID:** `org.programmershigh.rename`
### Rename with Pattern
**Action ID:** `rename.pattern`

パターンを指定して選択したファイルを一括でリネームします。以下のプレースホルダが使えます。

| プレースホルダ | 説明 | 例 |
|---|---|---|
| `{index}` | 1から始まる連番に置き換えます。 | `1`, `2`, `3` |
| `{index:N}` | 1から始まる連番に置き換えます。連番はN桁のゼロ埋め形式になります。 | `{index:2}` → `01` |
| `{name}` | 拡張子を除いた元のファイル名に置き換えます。 | `report` |
| `{name:upper}` | 拡張子を除いた元のファイル名を大文字に変換して置き換えます。 | `REPORT` |
| `{name:lower}` | 拡張子を除いた元のファイル名を小文字に変換して置き換えます。 | `report` |
| `{extension}` | 元の拡張子に置き換えます。 | `txt` |
| `{extension:upper}` | 元の拡張子を大文字に変換して置き換えます。 | `TXT` |
| `{extension:lower}` | 元の拡張子を小文字に変換して置き換えます。 | `txt` |
| `{modified:FORMAT}` | 更新日時に置き換えます。更新日時は指定書式になります（`yyyy` 年、`MM` 月、`dd` 日、`HH` 時、`mm` 分、`ss` 秒）。 | `{modified:yyyyMMdd}` → `20260321` |
## selection.lua
**Plugin ID:** `org.programmershigh.selection`
### Select Same Files in Inactive Pane
**Action ID:** `select.same.file`

フォーカスされていないパネルに同名のファイルが存在すれば選択します。
### Select Files Not in Inactive Pane
**Action ID:** `select.different.file`

フォーカスされていないパネルに同名のファイルが存在しなければ選択します。
### Select All Files Only
**Action ID:** `select.all.file`

全てのファイルを選択します。ディレクトリの選択状態は変更されません。
### Invert File Selection Only
**Action ID:** `select.invert.file`

全てのファイルの選択状態を反転します。ディレクトリの選択状態は変更されません。
### Select Files with Same Extension as Current Item
**Action ID:** `select.extension`

カーソルの置かれたファイルと拡張子が同じ全てのファイルを選択します。

## 配布元
このプラグインの配布元は以下です。  
https://github.com/marvelph/MartaPlugins

## ライセンス
ライセンスは [LICENSE](LICENSE) を参照してください。

## 連絡先
不具合報告や要望は GitHub の Issues にお願いします。  
https://github.com/marvelph/MartaPlugins/issues  
メール: marvel@programmershigh.org
