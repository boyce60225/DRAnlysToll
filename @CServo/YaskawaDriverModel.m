function sys_PosCloseLoopMinreal = YaskawaDriverModel( Pn100, Pn101, Pn102, Pn103, Pn401, Jm, Bm, a )
    % 增益值單位換算
    % Kpp(位置迴路增益)與Kvp(速度迴路增益)都換成(rad/s)
    % Ti(速度迴路積分時間常數)，Tt(扭力濾波時間常數)，都換成(sec)
    Kpp = Pn102 * 0.1;
    Kvp = Pn100 * 0.1 * ( 2 * pi );
    Tvi = Pn101 * 0.01 * 0.001;
    Tt = Pn401 * 0.01 * 0.001;
    % Jm,Bm為馬達轉子之轉動慣量與黏滯摩擦係數，平常Bm設定假設為0，在此情況下，Jm設定多少皆沒差，因為J會與Jhat對消。
    % J = ( 調機計算出的轉動慣量比 + 1 )* Jm
    %這邊假設調機的慣量比很準，J可以完全等同於馬達+機台的轉動慣量。
    J = ( 1 + Pn103 / 100 ) * Jm * a;
    Jhat = ( 1 + Pn103 / 100 ) * Jm;

    %見驅動器方塊圖的Kv(s)
    Num_KvS = [ Kvp * Jhat * Tvi, Kvp * Jhat ];
    Den_KvS = [ Tvi, 0 ];
    sys_KvS = tf( Num_KvS, Den_KvS );

    %見方塊圖的Ttau(s)
    Num_FtS = [ 1 ];
    Den_FtS = [ Tt, 1 ];
    sys_FtS = tf( Num_FtS, Den_FtS );

    %見方塊圖的G(s)
    Num_GS = [ 1 ];
    Den_GS = [ J, Bm ];
    sys_GS = tf( Num_GS, Den_GS );

    %計算速度迴路之開迴路與閉迴路的轉移函數
    sys_SpeedOpenLoop =  sys_KvS * sys_FtS * sys_GS;
    sys_SpeedClosedLoop = sys_SpeedOpenLoop / ( 1 + sys_SpeedOpenLoop );

    %將位置迴路增益與積分器包含進來
    Num_1 = [ Kpp ];
    Den_1 = [ 1, 0 ];
    sys_1 = tf( Num_1, Den_1 );

    %計算位置迴路之開迴路與閉迴路的轉移函數
    sys_PosOpenLoop =  sys_SpeedClosedLoop * sys_1;
    sys_PosCloseLoop = sys_PosOpenLoop / ( 1 + sys_PosOpenLoop );
    %Minreal化簡
    sys_PosCloseLoopMinreal = minreal(sys_PosCloseLoop);
end
