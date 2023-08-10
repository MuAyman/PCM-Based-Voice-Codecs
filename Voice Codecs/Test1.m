clear; clc;

%% input signal

[Input, fm] = audioread('k.mp3');
dTm = 1/fm;
v = size(Input);
Tm = 0;
Input(:,3) = Input(:,2);
Input(:,2) = Input(:,1);
for i = 1: v(1)     % to time the elemets
   Input(i,1) = Tm;
   Tm = Tm + dTm;
end
% plotting the input singal
%%%%%%%%%%%%%% The Right Sound %%%%%%%%%%%%%%
plot(Input(:,1),Input(:,2));
xlabel('Time (s)'); ylabel('Voltage (V)');
title('InputSignal(Right Sound)');
figure;
%%%%%%%%%%%%%% The left Sound %%%%%%%%%%%%%%
plot(Input(:,1),Input(:,2));
xlabel('Time (s)'); ylabel('Voltage (V)');
title('InputSignal(Left Sound)');
figure;

%% sampling 
fs = 20e3;
[smapledSignal] = Sampler(Input, fs);

%% quantizing
isMidrise = 1;
L = 32;
mp = 1;
[quantizedSignal,MSQE,BitStream] = Quantizer2(smapledSignal, isMidrise, L, mp);

sound(quantizedSignal(:,2:3), fs);
%% encoder
% R = 1+ ceil(log2(L));
% [S,D,Tb,Ap,R]=Encoder(BitStream(:,1:R));     % [encoded signal, decision(poler/ unipolar)]=
%                       % Encoder(quantized signal)

%% decoder

% 
% 
% ps=bandpower(A);      % estimating power of signal
% t = 0:Tb:Tb*(length(S)-1);
% 
% figure;
% tiledlayout(4,1)
% 
% % for N=0.5
% N=0.5;
% pn=(N)^2;             % signal power
% y = awgn(S,ps/pn);
% nexttile
% stairs(t,S,'linewidth',1)
% hold on
% stairs(t,y,'linewidth',1)
% legend('Pure Sampled Signal','Signal with Noise')
% title('For Standerd deviation =0.5')
% 
% 
% 
% % for N=1
% N=1;
% pn=(N)^2;             % signal power
% y = awgn(S,ps/pn);
% nexttile
% stairs(t,S,'linewidth',1)
% hold on
% stairs(t,y,'linewidth',1)
% legend('Pure Sampled Signal','Signal with Noise')
% title('For Standerd deviation =1')
% 
% % for N=3
% N=3;
% pn=(N)^2;             % signal power
% y = awgn(S,ps/pn);
% nexttile
% stairs(t,S,'linewidth',1)
% hold on
% stairs(t,y,'linewidth',1)
% legend('Pure Sampled Signal','Signal with Noise')
% title('For Standerd deviation =3')
% 
% % for N=05
% N=5;
% pn=(N)^2;             % signal power
% y = awgn(S,ps/pn);
% nexttile
% stairs(t,S,'linewidth',1)
% hold on
% stairs(t,y,'linewidth',1)
% legend('Pure Sampled Signal','Signal with Noise')
% title('For Standerd deviation =5')
% 
% 
% 
% W=Decoder(Q,R,D,Ap);
