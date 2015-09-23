% 1
% インタリーブの個数


% 2
% 並列カウンタ
local X in {Exchange C X X+1} end

% - 機能しない理由は?
% X+1 が束縛されてないので動かない

% - 修正せよ. これはデータフロー変数がない言語でも可能か?
% データフロー変数がない言語だと C:=@C+1 とかやらざるを得ず,
% これだと@C を参照して+1 するまでの間に interleave される可能性がある


% 3
% 最大並列性と効率


% 4
% 遅いネットワークをシミュレートすること


% 5
% どっかのデータフロー変数が bind されたら sync を待つ


% 6
% Communicating Sequential Processes (CSP)


% 10
% 大きなトランザクションの分割
% 8.4.5 で定義した Sum. 合計計算時にタプル中のすべてのセルをロックしていた.
% でっかいトランザクションじゃなく部分部分でロックしましょと
% トランザクション, total sum 保証できなくなってる


% 11
% ロックのキャッシュ