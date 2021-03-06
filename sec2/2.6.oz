%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2.6 核言語から実用言語へ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 使いやすいように糖衣構文を定義, 手を入れていく

%% 変数の暗黙初期化を使ってデータ構造を分離することもできる.
%% Tがレコードtreeに束縛済であれば,
local A B C D in
   T=tree(key:A left:B right:C value:D)
end
%% と書くことでA,B,C,Dに対応する値が束縛される. なぜなら束縛操作は実際は単一化であるため(2.8で後述).
%% CTMCPではこういう使い方を推奨しない, と言ってる
%% ...言っているが, たとえばClojureのdestructuringなどはそれをしている. 束縛済のものを1方向で分離する.

%% 入れ子マーカ(nesting marker)とは
local X in {Obj get(X)} {Browse X} end
%% の代わりに
{Browse {Obj get($)}}
%% と書くこと. よくわからん


%% 2.6.2 関数(fun文)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 「翻訳される」と言っているのは, 「核言語に」翻訳する話.
%% 関数定義と関数呼び出しは(手続きのそれの)糖衣構文に過ぎず, 同じ意味の手続き表現へと翻訳(核言語化)できる.

%% この関数定義は,
fun {Max X Y}
   if X>=Y then X else Y end
end

%% 次のような手続き定義に翻訳される.
proc {Max X Y ?R} %% ?はあってもなくてもokな視覚的marker
   R = if X>=Y then X else Y end
   %% もしくはこうでも.
   %% if X>=Y then R=X else R=Y end
end

%% モデル:
%%     fun {F X1 ... XN} <statement> <expression> end
%%     proc {F X1 ... XN ?R} <statement> R=<expression> end

%% 関数は必ず式で終わる
%% 手続きは必ず文で終わる

%% いままで出て来た"文"をどのように"式"に直すか, が表2.7

%% 入れ子になってれば奥のものから実行される
%% 並んでる時は最初に出てくるものから順に出てくる

Ys={F X} | {Map Xr F}

%% これは次のように翻訳される. 翻訳するときに「入れ子の関数呼び出しは束縛操作の後に置かれる」ことに注意.

local Y Ys in
   Ys=Y|Yr
   {F X Y}
   {Map Xr F Yr}
end

%% ちなみにMapは次のように定義できる

fun {Map Xs F}
   case Xs
   of nil then nil
   [] X|Xr then {F X} | {Map Xr F}
   end
end

%% [] X|Xr then, の部分は[]もしくはX|Xrの形が来たらマッチするよーと候補を複数並べてるのか.


%% 2.6.3 対話的インターフェイス(declare文)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 本の例題ではdeclareを省略してることが多いが, 実際は新しい変数を使う前にdeclareしろよ, とのこと
%% ちなみにdeclareするたびに新しい未束縛の格納域が出来る.
%% 対話的インターフェイスは"単一の大域的環境"を持つ. declareはここに新しい写像を追加する.