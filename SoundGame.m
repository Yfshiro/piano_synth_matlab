clc;clear;close all;%清场子

%% 参数设置
SFT=0;%移调，负值为降调，正值为升调。单位为一个八度。
time=0.4;%每拍长度(秒)
HI=1;%高音区增益(C3-B4)
LO=1;%低音区增益(C5-C7)

%% 素材处理
[music4,fs]=audioread('herm.mp3');%偷一个C4(中央C)
music4=music4(:,1);%提取单声道
disp('基音载入完成');

figure;plot(music4);title('C4素材');grid on;%瞅一眼波形长啥样
pause(0.001);

%鼠标点击裁剪
xlabel('请用使用鼠标确定裁剪位置(起止点)');
[cut,tp]=ginput(2);%从鼠标点击获取起止点
START=round(min(cut));
END=round(max(cut));

C4=music4(START:END,1);%裁剪一下捕获C4波形  C4负责衍生C3-B7
C4=C4.*1;%增益补偿

line([START,START],[min(C4),max(C4)],'color','g','linestyle','--');%识别位置（峰值识别)
line([START,START],[min(C4),max(C4)],'color','r','linestyle','--');%起始裁剪
line([END,END],[min(C4),max(C4)],'color','r','linestyle','--');%结束裁剪

legend('素材','峰值','裁剪区间');
pause(0.00001);

%% 推导得出C3-C8
%★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
%★                       本代码中的音符表示(以C4-B4为例)                                      ★           
%★                                                                                           ★    
%★序号：  1     2      3     4     5     6      7        8       9     10     11      12     ★        
%★音阶：  C     C#     D     D#    E     F      F#       G       G#    A      A#      B      ★       
%★简谱：  1     1#     2     2#    3     4      4#       5       5#    6      6#      7      ★  
%★代码：  C4    CU4    D4    DU4   E4    F4     FU4      G4      GU4   A4     AU4     B4     ★  
%★                                                                                           ★                   
%★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
%根据十二平均律，以上每个音阶间频率就是个公比为(1/2)^12的等差数列 2^(1/12)


temp=rats(1/2^((-12+SFT*12)/12));%将公比转化为分数
p=str2num(temp(1:strfind(temp,'/')-1));%被除数
q=str2num(temp(strfind(temp,'/')+1:end));%除数
if isempty(strfind(temp,'/'))
    p=str2num(temp);
    q=1;
end
C3=resample(C4,p,q);%先推导出最低音以确定所有音的峰值位置
[tp,MX]=max(C3);
M=zeros(length(C3),60);NL=C3.*0;count=0;
for i=-12+(SFT*12):47+(SFT*12)%基于C4衍生出C3-B7
    count=count+1;
    temp=rats(1/2^(i/12));%将公比转化为分数
    p=str2num(temp(1:strfind(temp,'/')-1));%被除数
    q=str2num(temp(strfind(temp,'/')+1:end));%除数
    if isempty(strfind(temp,'/'))
        p=str2num(temp);
        q=1;
    end
    temp2=resample(C4,p,q);%通过改变采样率实现变调
%     try  %规范化存入
%         M(:,count)=temp2(1:length(NL));%音长比容量长
%     catch
        M(1:length(temp2),count)=temp2;%音长比容量短
%     end
    [tp,mx]=max(M(:,count));%mx为当前音符峰值位置
    M((MX-mx+1):end,count)=M(1:(end-(MX-mx)),count); %对齐峰值(所有音峰值位置钧比C3提前，故右移补零即可)
    M(1:(MX-mx),count)=M(1:(MX-mx),count).*0;
end
M(:,1:24)=M(:,1:24).*LO;%低音增益(C3-B4)
M(:,25:60)=M(:,25:60).*HI;%高音增益(C5-B7)
disp('C3-B7生成完毕');
disp('开始测试');
for i=1:60%试听
    disp(i)
    sound(M(:,i),fs);
    for i=1:8
        fprintf('%c',8);%删
    end
%     pause(0.05);
end
pause(0.5);
% for i=1:60*8
%     fprintf('%c',8);%删
% end
disp('测试完成');
disp('正在指定音符...');

%% 给各音阶标上助记符
C3=M(:,1);CU3=M(:,2);D3=M(:,3);DU3=M(:,4);E3=M(:,5);F3=M(:,6);FU3=M(:,7);G3=M(:,8);GU3=M(:,9);A3=M(:,10);AU3=M(:,11);B3=M(:,12);
C4=M(:,13);CU4=M(:,14);D4=M(:,15);DU4=M(:,16);E4=M(:,17);F4=M(:,18);FU4=M(:,19);G4=M(:,20);GU4=M(:,21);A4=M(:,22);AU4=M(:,23);B4=M(:,24);
C5=M(:,25);CU5=M(:,26);D5=M(:,27);DU5=M(:,28);E5=M(:,29);F5=M(:,30);FU5=M(:,31);G5=M(:,32);GU5=M(:,33);A5=M(:,34);AU5=M(:,35);B5=M(:,36);
C6=M(:,37);CU6=M(:,38);D6=M(:,39);DU6=M(:,40);E6=M(:,41);F6=M(:,42);FU6=M(:,43);G6=M(:,44);GU6=M(:,45);A6=M(:,46);AU6=M(:,47);B6=M(:,48);
C7=M(:,49);CU7=M(:,50);D7=M(:,51);DU7=M(:,52);E7=M(:,53);F7=M(:,54);FU7=M(:,55);G7=M(:,56);GU7=M(:,57);A7=M(:,58);AU7=M(:,59);B7=M(:,60);
HOLD=C4.*0;%延音符

%% 编曲
disp('正在编曲...');

melody=[...%编曲   U表示升半调    "+"号表示和弦   每行用"..."结尾
% % % E4 HOLD HOLD E4 HOLD D4 E4 G4 E4 A4 HOLD HOLD HOLD B4 C5 D5 HOLD G4 HOLD E5 HOLD A4 HOLD C5 HOLD E5 HOLD D5 HOLD  HOLD G5 HOLD E5 HOLD A5 HOLD  HOLD  HOLD D5 E5 A5 B5 HOLD  HOLD E3 E3 G3 A3 HOLD E4 HOLD A3 HOLD G3 HOLD A3 A3 G3 A3  HOLD A3 A3 G3 A3 HOLD E4 HOLD D4 C4 C4 HOLD D4 D4 G4 E4  HOLD E3 G3 A3 HOLD E4 HOLD A3 HOLD G3 A3 HOLD G3 A3 G3 E4 D4 D4 HOLD  HOLD  HOLD C4 D4 HOLD B3 HOLD  HOLD  HOLD E3 E3 G3 
G4  HOLD G4  A4  D4 HOLD HOLD  C4 HOLD  C4  A3  D4 HOLD HOLD  ...%东方红太阳升
G4 HOLD  G4 HOLD  A4  C5  A4  G4  C4 HOLD  C4  A3  D4 HOLD HOLD  ...%中国出了个毛泽东
G4 HOLD  D4 HOLD  C4 HOLD  B3  A3  G3 HOLD  G4 HOLD  D4 HOLD  ...%他为人民谋幸福
E4  D4  C4 HOLD  C4  A3  D4 E4 D4 C4 D4 C4 B3 A3 G3 HOLD  ...%呼哎嘿哟他是人民大救星
% G5 HOLD HOLD G5 HOLD C6 HOLD HOLD B5 HOLD A5 HOLD B5 HOLD C6 HOLD D6 HOLD C6 HOLD HOLD G5 G5 HOLD HOLD HOLD HOLD HOLD HOLD...
% A3+C6+C7 E4+A4 A3 E4+A4 A5+A6+A3 E4+A4 A3+C6+C7 E4+A4 G3+B5+B6 D4+G4 G3 D4+G4 G3+G5+G6 D4+G4 G3+E5+E6 D4+G4...
% F3+C6+C7 C4+F4+B5+B6 F3+A5+A6 C4+F4+G5+G6 F3+A5+A6 C4+F4 F3+E6+E7 C4+F4 E3+B5+B6 B3+E4 E3 B3+E4 E3+GU5+GU6 B3+E4 E3+E5+E6...
% B3+E4 D3+A5+A6 A3+D4+A5+A6 D3+G5+G6 A3+D4+F5+F6 D3+E5+E6 A3+D4+D5+D6 D3+E5+E6 A3+D4+F5+F6 E3+E5+E6 B3+E4 E3+B5+B6 B3+E4 F3+GU5+GU6 B3+E4 E3+E5+E6 B3+E4...
% D3+A5+A6 A3+D4+A5+A6 D3+G5+G6 A3+D4+F5+F6 E3+E5+E6 A3+D4+D5+D6 D3+E5+E6 A3+D4+F5+F6 E3+E5+E6 B3+E4 E3+B5+B6 B3+E4 E3 B3+E4 E3 B3+E4 A3+E4+A4+C6+C7 A3+E4+A4 A3+E4+A4 A3+E4+A4 A3+E4+A4+A5+A6 A3+E4+A4 A3+E4+A4+C6+C7 A3+E4+A4...
% G3+D4+G4+B5+B6 G3+D4+G4 G3+D4+G4 G3+D4+G4 G3+D4+G4+G5+G6 G3+D4+G4 G3+D4+G4+E5+E6 G3+D4+G4 F3+C4+F4+C6+C7 F3+C4+F4+B5+B6 F3+C4+F4+A5+A6 F3+C4+F4+G5+G6 F3+C4+F4+A5+A6 F3+C4+F4 F3+C4+F4+E6+E7 F3+C4+F4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4 E3+B3+E4+E5+E6 E3+B3+E4...
% D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6 E3+B3+E4+E5+E6 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4 E3+B3+E4+E5+E6 E3+B3+E4 D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6...
% E3+B3+E4+E5+E6 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 HOLD HOLD A4+C6 E5 C5 E5 A4+A5 E5 C5+C6 E5...%MARK
% G4+B5 D5 B4 D5 G4+G5 D5 B4+E5 D5 F4+C6 C5+B5 A4+A5 C5+G5 F4+A5 C5 A4+E6 C5 E4+B5 B4 G4 B4 E4+GU5 B4 G4+E5 B4...
% D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5 E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5...
% E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 A4+E6 E5 C5 E5+D6 A4+E6 E5 C5 E5+D6 G4+E6 D5 B4+B5 D5 G4+G5 D5 B4+E5 D5...
% F4+E6 C5 A4 C5+D6 F4+E6 C5 A4 C5+D6 E4+E6 B4 G4+B5 B4 E4 B4 G4 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5...
% E4+B5 B4 G4+E6 B4 E4+B5 B4 G4+GU5 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5 E4+B5 B4 G4+E6 B4 E4 B4 G4 B4...%MARK
% A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4 G3+D4+G4+B5+B6  G3+D4+G4 G3+D4+G4+G5+G6 G3+D4+G4 G3+D4+G4+E5+E6 G3+D4+G4 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7...
% E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4...
% D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7  A3+E4+A4+A5+A6  A3+E4+A4+A5+A6  A3+E4+A4+C6+C7  A3+E4+A4+C6+C7...
% G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6  G3+D4+G4+G5+G6  G3+D4+G4+E5+E6 G3+D4+G4+E5+E6 F3+C4+F4+C6+C7 F3+C4+F4+B5+B6  F3+C4+F4+A5+A6  F3+C4+F4+G5+G6  F3+C4+F4+A5+A6  F3+C4+F4+A5+A6 F3+C4+F4+E6+E7 F3+C4+F4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6...
% D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6...
% E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6 G3+D4+G4+G5+G6 G3+D4+G4+E5+E6 G3+D4+G4+E5+E6...
% A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6...
% E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 HOLD...%MARK
% A4+C6 E5 C5 E5 A4+A5 E5 C5+C6 E5 G4+B5 D5 B4 D5 G4+G5 D5 B4+E5 D5 F4+C6 C5+B5 A4+A5 C5+G5 F4+A5 C5 A4+E6 C5 E4+B5 B4 G4 B4 E4+GU5 B4 G4+E5 B4...
% D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5 E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5...
% E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 A4+E6 E5 C5 E5+D6 A4+E6 E5 C5 E5+D6 G4+E6 D5 B4+B5 D5 G4+G5 D5 B4+E5 D5...
% F4+E6 C5 A4 C5+D6 F4+E6 C5 A4 C5+D6 E4+E6 B4 G4+B5 B4 E4 B4 G4 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5...
% E4+B5 B4 G4+E6 B4 E4+B5 B4 G4+GU5 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5 E4+B5 B4 G4+E6 B4 E4 B4 G4 B4...
% A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4 G3+D4+G4+B5+B6  G3+D4+G4 G3+D4+G4+G5+G6 G3+D4+G4 G3+D4+G4+E5+E6 G3+D4+G4 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7...
% E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4...
% D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7  A3+E4+A4+A5+A6  A3+E4+A4+A5+A6  A3+E4+A4+C6+C7  A3+E4+A4+C6+C7...
% G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6  G3+D4+G4+G5+G6  G3+D4+G4+E5+E6 G3+D4+G4+E5+E6 F3+C4+F4+C6+C7 F3+C4+F4+B5+B6  F3+C4+F4+A5+A6  F3+C4+F4+G5+G6  F3+C4+F4+A5+A6  F3+C4+F4+A5+A6 F3+C4+F4+E6+E7 F3+C4+F4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6...
% D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6...
% E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6 G3+D4+G4+G5+G6 G3+D4+G4+E5+E6 G3+D4+G4+E5+E6...
% A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6...
% E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6...
% C7 HOLD HOLD HOLD HOLD A6 HOLD HOLD C7 HOLD HOLD B6 HOLD HOLD HOLD HOLD HOLD HOLD G6 HOLD HOLD HOLD E6.*2+E3.*2 HOLD HOLD HOLD HOLD...

];


%% 生成波形

time=time*fs;
[temp3,len]=size(melody);%获取歌取长度(按拍数计)
Melody=zeros((len-1)*time+length(C4),2);
disp('正在生成波形●●●●●●●●●●');fprintf('%c', 8);%删掉换行符
for i=0:len-1
    Melody(i*time+1:i*time+length(C4),1)=melody(:,i+1)+Melody(i*time+1:i*time+length(C4),1);%编入波形
    if (mod(round(i/len*100),10)==0)&&(mod(round((i-1)/len*100),10)~=0)
        fprintf('%c', 8);%删
    end
end
disp(' ');
Melody(:,2)=Melody(:,1);
disp('波形生成完毕，开始演奏');
disp('    ');
%% 演奏
figure;plot(Melody);
xlabel('提示：在波形上单击,将从单击的位置开始演奏');
str=['总时长 ',num2str(floor(length(Melody)/fs/60)),':',num2str(round(length(Melody)/fs-60*floor(length(Melody)/fs/60)))];
title(str);%显示歌曲总时长
grid on;
pause(0.0001);
set(gcf,'WindowButtonDownFcn',@ButttonDownFcn);%使能鼠标中断读取函数
global startpoint%默认从头(波形第1位)开始播放
global flag%标志位(为0时重新播放，为1时继续)
startpoint=1;
temp4=1;%制造死循环

while temp4==1%%%%%演奏开始
    flag=1;
    EndFlag=0;
    sound(Melody(round(startpoint):end,:),fs);%演奏
    tic;%开始计时
    while temp4==1%画进度条
        L1=line([toc*fs+startpoint-1,toc*fs+startpoint-1],[min(Melody(:,1)),max(Melody(:,1))],'color','b','linestyle','-');
        if length(Melody)<=toc*fs+startpoint-1 
           EndFlag=1;%若播放结束则不再循环
           break;
        end
        if flag==0%重新演奏
            break;
        end
        pause(0.05);
        delete(L1);
    end
    
    clear sound;%清除声音
    try
        delete(L1);%清除进度条
    catch
        continue;
    end
    if EndFlag==1
        disp('谢谢欣赏');
        break;%终结程序
    end

end



% 回调函数
function ButttonDownFcn(src,event)
    for i=1:5
        fprintf('%c',8);%删
    end
    clear sound;
    pt = get(gca,'CurrentPoint');%获取鼠标位置
    fprintf('跳转播放\n');%显示
    global startpoint%只有全局变量才能传出去
    global flag
    startpoint=pt(1,1);%根据鼠标点击设定播放起始点
    if startpoint<1
        startpoint=1;%处理鼠标点到负值的情况
    end
    flag=0;%重新播放
    
end



 %% 演奏
% figure;plot(Melody);
% xlabel('提示：在命令行窗口输入clear sound结束演奏');
% str=['总时长 ',num2str(floor(length(Melody)/fs/60)),':',num2str(round(length(Melody)/fs-60*floor(length(Melody)/fs/60)))];
% title(str);%显示歌曲总时长
% grid on;
% pause(0.0001);
% sound(Melody,fs);%演奏
% 
% tic;%开始计时
% temp4=1;
% while temp4==1%画进度条
%     L1=line([toc*fs,toc*fs],[min(Melody(:,1)),max(Melody(:,1))],'color','b','linestyle','-');
%     pause(0.0001);
%     delete(L1);
%     if length(Melody)/fs<=toc
%        break; 
%     end
% end