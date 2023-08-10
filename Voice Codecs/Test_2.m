clear
clc

[Input,fm] = audioread('k.mp3');
dTm = 1/fm;
Tm = 0;
v = size(Input);

for i = 1: v(1)     % to time the elemets
   Input(i,1) = Tm;
   Tm = Tm + dTm;
end

%%plotting the input singal
plot(Input(:,1),Input(:,2));
xlabel('Time (s)'); ylabel('Voltage (V)');
title('InputSignal');
figure;

Fs=10000;            %% sampling frequency in Hz 
mp=1;      %% Quantizer peak level
L=64;                %% Quantizer number of levels.
R = ceil(log2(L));   %% # of bits per sample 
isMidrise=1;
bb=1/(R*Fs);


[smapledSignal] = Sampler(Input, Fs);

[quantizedSignal,MSQE,BitStream] = Quantizer2(smapledSignal, isMidrise, L, mp);
[A_encoded,Decision,Tb,Ap,R]=Encoder(BitStream(:,1:R));

% plot(Input(:,1),A_encoded);
% xlabel('Time (s)'); ylabel('Voltage (V)');
% title('Encoded Signal');
% figure;

ps=bandpower(Input(:,1)); 
% for N=0.5
N=0.5;
pn=(N)^2;             % signal power
y = awgn(A_encoded,ps/pn);

[A_regen]=Regenerater(y,R, Decision,Ap);

[D]=Decoder(A_regen,R,Decision,Ap,BitStream(:,R+2));
sound(D,Fs);

filename = 'Again.wav';
%%afw = dsp.AudioFileWriter(filename,C);
audiowrite(filename,D,Fs);