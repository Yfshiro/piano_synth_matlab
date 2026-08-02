clc;clear;close all;%清场子
disp('正在载入基音...');
[music4,fs]=audioread('C4.mp3');%偷一个C4(中央C)
[music7,fs]=audioread('C7.mp3');%偷一个C7
disp('基音载入完成');

figure;subplot(211);plot(music4);title('C4素材');grid on;subplot(212);plot(music7);title('C7素材');grid on;%瞅一眼波形长啥样
pause(0.001);%等待作图结束
L=226105;%根据瞅一眼的结果确定裁取的音长←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
NZ4=find(music4);NZ4=NZ4(1);
NZ7=find(music7);NZ7=NZ7(1);%查出波形中第一个不为零的点
C4=music4(NZ4:NZ4+L,1);%裁剪一下捕获C4波形  C4负责衍生C2-B4
C7=music7(NZ7:NZ7+L,1);%裁剪一下捕获C7波形  C7负责衍生C5-B8
C4=C4.*2;%←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
C7=C7.*3;%增益补偿←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←←
subplot(211);hold on;
line([NZ4,NZ4],[min(C4),max(C4)],'color','r','linestyle','--');%起始裁剪
line([NZ4+L,NZ4+L],[min(C4),max(C4)],'color','r','linestyle','--');%结束裁剪
subplot(212);hold on;
line([NZ7,NZ7],[min(C7),max(C7)],'color','r','linestyle','--');%起始裁剪
line([NZ7+L,NZ7+L],[min(C7),max(C7)],'color','r','linestyle','--');%结束裁剪
pause(0.00001);
figure;subplot(211);plot(C4);title('C4');grid on;subplot(212);plot(C7);title('C7');grid on;%查看裁剪
pause(0.00001);

%% 推导得出C2-B7（十二平均律）

%序号：  1     2      3     4     5     6      7        8       9     10     11      12
%音阶：  C     C#     D     D#    E     F      F#       G       G#    A      A#      B   
%简谱：  1     1#     2     2#    3     4      4#       5       5#    6      6#      7
%本代码中的表示(以C4-B4为例):
%        C4    CU4    D4    DU4   E4    F4     FU4      G4      GU4   A4     AU4     B4   
% 
%根据十二平均律，以上每个音阶间频率就是个公比为(1/2)^12的等差数列 2^(1/12)

M=zeros(length(C4),84);NL=C4.*0;count=0;
for i=-24:11%基于C4衍生出C2-B4
    count=count+1;%第count拍
    temp=rats(1/2^(i/12));%将公比转化为分数
    p=str2num(temp(1:strfind(temp,'/')-1));%被除数
    q=str2num(temp(strfind(temp,'/')+1:end));%除数
    if isempty(strfind(temp,'/')) % 处理 没有分数符号 ('/') 的情况
        p=str2num(temp);
        q=1;
    end
    temp2=resample(C4,p,q);%通过改变采样率实现变调
    try  %规范化存入,让每一拍长度都一样，取最长的那拍的长度
        M(:,count)=temp2(1:length(NL));%音长比容量短
    catch
        M(1:length(temp2),count)=temp2;%音长比容量长
    end
end
disp('C2-B4生成完毕');
for i=-24:23%基于C7衍生出C5-B8
    count=count+1;
    temp=rats(1/2^(i/12));%将公比转化为分数
    p=str2num(temp(1:strfind(temp,'/')-1));%被除数
    q=str2num(temp(strfind(temp,'/')+1:end));%除数
    if isempty(strfind(temp,'/'))
        p=str2num(temp);
        q=1;
    end
    temp2=resample(C7,p,q);%通过改变采样率实现变调
    try  %规范化存入
        M(:,count)=temp2(1:length(NL));%音长比容量短
    catch
        M(1:length(temp2),count)=temp2;%音长比容量长
    end
end
disp('C5-B7生成完毕');
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

%% 指定音符(给各音阶标上助记符)
disp('正在指定音符...');
C2=M(:,1);CU2=M(:,2);D2=M(:,3);DU2=M(:,4);E2=M(:,5);F2=M(:,6);FU2=M(:,7);G2=M(:,8);GU2=M(:,9);A2=M(:,10);AU2=M(:,11);B2=M(:,12);
C3=M(:,13);CU3=M(:,14);D3=M(:,15);DU3=M(:,16);E3=M(:,17);F3=M(:,18);FU3=M(:,19);G3=M(:,20);GU3=M(:,21);A3=M(:,22);AU3=M(:,23);B3=M(:,24);
C4=M(:,25);CU4=M(:,26);D4=M(:,27);DU4=M(:,28);E4=M(:,29);F4=M(:,30);FU4=M(:,31);G4=M(:,32);GU4=M(:,33);A4=M(:,34);AU4=M(:,35);B4=M(:,36);
C5=M(:,37);CU5=M(:,38);D5=M(:,39);DU5=M(:,40);E5=M(:,41);F5=M(:,42);FU5=M(:,43);G5=M(:,44);GU5=M(:,45);A5=M(:,46);AU5=M(:,47);B5=M(:,48);
C6=M(:,49);CU6=M(:,50);D6=M(:,51);DU6=M(:,52);E6=M(:,53);F6=M(:,54);FU6=M(:,55);G6=M(:,56);GU6=M(:,57);A6=M(:,58);AU6=M(:,59);B6=M(:,60);
C7=M(:,61);CU7=M(:,62);D7=M(:,63);DU7=M(:,64);E7=M(:,65);F7=M(:,66);FU7=M(:,67);G7=M(:,68);GU7=M(:,69);A7=M(:,70);AU7=M(:,71);B7=M(:,72);
C8=M(:,73);CU8=M(:,74);D8=M(:,75);DU8=M(:,76);E8=M(:,77);F8=M(:,78);FU8=M(:,79);G8=M(:,80);GU8=M(:,81);A8=M(:,82);AU8=M(:,83);B8=M(:,84);
HOLD=C4.*0;%延音符

%% 编曲
disp('正在编曲...');
time=0.25;%每拍长度(秒)
melody=[...%编曲   U表示升半调    "+"号表示和弦   每行用"..."结尾
HOLD HOLD HOLD HOLD HOLD HOLD...    
G6 HOLD HOLD G6 HOLD C7 HOLD HOLD B6 HOLD A6 HOLD B6 HOLD C7 HOLD D7 HOLD C7 HOLD HOLD G6 G6 HOLD HOLD HOLD HOLD HOLD HOLD...
A3+C6+C7 E4+A4 A3 E4+A4 A5+A6+A3 E4+A4 A3+C6+C7 E4+A4 G3+B5+B6 D4+G4 G3 D4+G4 G3+G5+G6 D4+G4 G3+E5+E6 D4+G4...
F3+C6+C7 C4+F4+B5+B6 F3+A5+A6 C4+F4+G5+G6 F3+A5+A6 C4+F4 F3+E6+E7 C4+F4 E3+B5+B6 B3+E4 E3 B3+E4 E3+GU5+GU6 B3+E4 E3+E5+E6...
B3+E4 D3+A5+A6 A3+D4+A5+A6 D3+G5+G6 A3+D4+F5+F6 D3+E5+E6 A3+D4+D5+D6 D3+E5+E6 A3+D4+F5+F6 E3+E5+E6 B3+E4 E3+B5+B6 B3+E4 F3+GU5+GU6 B3+E4 E3+E5+E6 B3+E4...
D3+A5+A6 A3+D4+A5+A6 D3+G5+G6 A3+D4+F5+F6 E3+E5+E6 A3+D4+D5+D6 D3+E5+E6 A3+D4+F5+F6 E3+E5+E6 B3+E4 E3+B5+B6 B3+E4 E3 B3+E4 E3 B3+E4 A3+E4+A4+C6+C7 A3+E4+A4 A3+E4+A4 A3+E4+A4 A3+E4+A4+A5+A6 A3+E4+A4 A3+E4+A4+C6+C7 A3+E4+A4...
G3+D4+G4+B5+B6 G3+D4+G4 G3+D4+G4 G3+D4+G4 G3+D4+G4+G5+G6 G3+D4+G4 G3+D4+G4+E5+E6 G3+D4+G4 F3+C4+F4+C6+C7 F3+C4+F4+B5+B6 F3+C4+F4+A5+A6 F3+C4+F4+G5+G6 F3+C4+F4+A5+A6 F3+C4+F4 F3+C4+F4+E6+E7 F3+C4+F4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4 E3+B3+E4+E5+E6 E3+B3+E4...
D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6 E3+B3+E4+E5+E6 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4 E3+B3+E4+E5+E6 E3+B3+E4 D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6...
E3+B3+E4+E5+E6 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 HOLD HOLD A4+C6 E5 C5 E5 A4+A5 E5 C5+C6 E5...%MARK
G4+B5 D5 B4 D5 G4+G5 D5 B4+E5 D5 F4+C6 C5+B5 A4+A5 C5+G5 F4+A5 C5 A4+E6 C5 E4+B5 B4 G4 B4 E4+GU5 B4 G4+E5 B4...
D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5 E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5...
E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 A4+E6 E5 C5 E5+D6 A4+E6 E5 C5 E5+D6 G4+E6 D5 B4+B5 D5 G4+G5 D5 B4+E5 D5...
F4+E6 C5 A4 C5+D6 F4+E6 C5 A4 C5+D6 E4+E6 B4 G4+B5 B4 E4 B4 G4 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5...
E4+B5 B4 G4+E6 B4 E4+B5 B4 G4+GU5 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5 E4+B5 B4 G4+E6 B4 E4 B4 G4 B4...%MARK
A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4 G3+D4+G4+B5+B6  G3+D4+G4 G3+D4+G4+G5+G6 G3+D4+G4 G3+D4+G4+E5+E6 G3+D4+G4 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7...
E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4...
D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7  A3+E4+A4+A5+A6  A3+E4+A4+A5+A6  A3+E4+A4+C6+C7  A3+E4+A4+C6+C7...
G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6  G3+D4+G4+G5+G6  G3+D4+G4+E5+E6 G3+D4+G4+E5+E6 F3+C4+F4+C6+C7 F3+C4+F4+B5+B6  F3+C4+F4+A5+A6  F3+C4+F4+G5+G6  F3+C4+F4+A5+A6  F3+C4+F4+A5+A6 F3+C4+F4+E6+E7 F3+C4+F4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6...
D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6...
E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6 G3+D4+G4+G5+G6 G3+D4+G4+E5+E6 G3+D4+G4+E5+E6...
A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6...
E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 HOLD...%MARK
A4+C6 E5 C5 E5 A4+A5 E5 C5+C6 E5 G4+B5 D5 B4 D5 G4+G5 D5 B4+E5 D5 F4+C6 C5+B5 A4+A5 C5+G5 F4+A5 C5 A4+E6 C5 E4+B5 B4 G4 B4 E4+GU5 B4 G4+E5 B4...
D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5 E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 D4+A5 A4+A5 F4+G5 A4+F5 D4+E5 A4+D5 F4+E5 A4+F5...
E4+E5 B4 G4+B5 B4 E4+GU5 B4 G4+E5 B4 A4+E6 E5 C5 E5+D6 A4+E6 E5 C5 E5+D6 G4+E6 D5 B4+B5 D5 G4+G5 D5 B4+E5 D5...
F4+E6 C5 A4 C5+D6 F4+E6 C5 A4 C5+D6 E4+E6 B4 G4+B5 B4 E4 B4 G4 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5...
E4+B5 B4 G4+E6 B4 E4+B5 B4 G4+GU5 B4 D4+C6 A4+C6 F4+B5 A4+A5 D4+G5 A4+F5 F4+G5 A4+A5 E4+B5 B4 G4+E6 B4 E4 B4 G4 B4...
A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4 A3+E4+A4 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4 G3+D4+G4+B5+B6  G3+D4+G4 G3+D4+G4+G5+G6 G3+D4+G4 G3+D4+G4+E5+E6 G3+D4+G4 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7 F3+C4+F4+E6+E7 F3+C4+F4 F3+C4+F4 F3+C4+F4+D6+D7...
E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+GU5+GU6 E3+B3+E4...
D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4 E3+B3+E4+E6+E7 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 E3+B3+E4 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7 A3+E4+A4+C6+C7  A3+E4+A4+A5+A6  A3+E4+A4+A5+A6  A3+E4+A4+C6+C7  A3+E4+A4+C6+C7...
G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6  G3+D4+G4+G5+G6  G3+D4+G4+E5+E6 G3+D4+G4+E5+E6 F3+C4+F4+C6+C7 F3+C4+F4+B5+B6  F3+C4+F4+A5+A6  F3+C4+F4+G5+G6  F3+C4+F4+A5+A6  F3+C4+F4+A5+A6 F3+C4+F4+E6+E7 F3+C4+F4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6...
D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 D3+A3+D4+A5+A6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+E5+E6 D3+A3+D4+D5+D6 D3+A3+D4+E5+E6 D3+A3+D4+F5+F6...
E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 E3+B3+E4+E5+E6 E3+B3+E4+E5+E6 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+G5+G6 G3+D4+G4+G5+G6 G3+D4+G4+E5+E6 G3+D4+G4+E5+E6...
A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+E6+E7 A3+E4+A4+D6+D7 G3+D4+G4+E6+E7 G3+D4+G4+E6+E7 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 G3+D4+G4+B5+B6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6...
E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6 D3+A3+D4+C6+C7 D3+A3+D4+C6+C7 D3+A3+D4+B5+B6 D3+A3+D4+A5+A6 D3+A3+D4+G5+G6 D3+A3+D4+F5+F6 D3+A3+D4+G5+G6 D3+A3+D4+A5+A6 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+E6+E7 E3+B3+E4+E6+E7 E3+B3+E4+B5+B6 E3+B3+E4+B5+B6 E3+B3+E4+GU5+GU6 E3+B3+E4+GU5+GU6...
C7 HOLD HOLD HOLD HOLD A6 HOLD HOLD C7 HOLD HOLD B6 HOLD HOLD HOLD HOLD HOLD HOLD G6 HOLD HOLD HOLD E6.*2+E3.*2 HOLD HOLD HOLD HOLD...

];

%% 生成波形

time=time*fs;%每拍的点数
[temp3,len]=size(melody);%获取歌取长度(拍数)
Melody=zeros((len-1)*time+length(C4),2);
disp('正在生成波形★★★★★★★★★★');fprintf('%c', 8);%删掉换行符
for i=0:len-1   %如果 Melody(i * time + 1:i * time + length(C4), 1)已经有数据例如它之前的音符），那么它会叠加到现有的波形上，这样就能实现多个音符同时播放
    Melody(i*time+1:i*time+length(C4),1)=melody(:,i+1)+Melody(i*time+1:i*time+length(C4),1);
    if (mod(round(i/len*100),10)==0)&&(mod(round((i-1)/len*100),10)~=0)%每完成 10% 的进度时，会删掉一个★
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
% 向下取整，得到 歌曲的整数分钟数。                                   计算出歌曲总时长（秒），然后减去已经转换为分钟的部分
str=['总时长 ',num2str(floor(((len-1)*time+length(C4))/fs/60)),':',num2str(round(((len-1)*time+length(C4))/fs-60*floor(((len-1)*time+length(C4))/fs/60)))];
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
        hold on;
        L1=line([toc*fs+startpoint-1,toc*fs+startpoint-1],[min(Melody(:,1)),max(Melody(:,1))],'color','b','linestyle','-');
        if ((len-1)*time+length(C4))<=toc*fs+startpoint-1 
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