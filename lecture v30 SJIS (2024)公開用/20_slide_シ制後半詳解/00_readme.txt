編集の仕方

【テーマの変更】
slide.tex の
\usetheme{テーマ名}
で変更
以下のページを参考にシンプルな物を選定
http://tex.y-misc.org/beamer/theme.html


【グラフのパス】
\graphicspath{{../}}		%% LECTURE.tex がある場所
は相対パスを使って図を読みに行く（フォルダの置き場に合わせて設定）


【色付け】
\Blue{}, \Red{}
などで囲むとできる．
詳細はcustom.sty の
\newcommand{\Red}[1]{\textcolor{red}{#1}}
同様にして好きな色を増やせる．


【囲み】
\begin{block}{タイトル（タイトルがいらない場合は空白）}
\end{block}
で青い囲みができる．
同様に
\begin{alertblock}{タイトル（タイトルがいらない場合は空白）}
\end{alertblock}
で赤い囲み
\begin{exampleblock}{タイトル（タイトルがいらない場合は空白）}
\end{exampleblock}
で緑の囲み
ができる．

【段組み】
つぎのように行う．
段の比率は0.3 や0.7 で行う．
\begin{columns}
\begin{column}{0.3\textwidth}
hogehoge
\end{column}
\begin{column}{0.7\textwidth}
fugafuga
\end{column}
\end{columns}


