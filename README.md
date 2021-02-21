# mayapy_package_utilities
Mayaで使用するpythonパッケージでサブモジュールとして使用するためのユーティリティ

| ファイル名 | 概要 |
| ---- | ---- |
| setup.py | 親リポジトリの依存パッケージを解決するためのPythonスクリプト<br>setup.batから呼び出してこのパッケージ用の環境を設定するほか、親リポジトリをpip install可能なパッケージにするために親階層にコピーして使用する |
| setup.bat | インストールされているMayaを検索し、mayapyを使用してpip installで依存パッケージをインストールする<br>またsetup.pyの親階層へのコピーも行う
