function [quantizedSignal,MSQE,BitStream] = Quantizer2(y, isMidrise, L, mp)
% this function quantizes discrete signals
% signal = two vector sampled signal (a time vector & an amplitude vector)
% L = the number of levels
% mp = the peak quantization level
% isMidrise = 1 (mid-rise) or 0 (mid-tread)

%% Intializations
v = size(y);
SignalElementsNo = v(1);
step = 2*mp/L;
R = 1+ceil(log2(L));
quantizedSignal(:,1) = y(:,1);
BitStream(:,1) = y(:,1);

%% Quantization
for i = 1:SignalElementsNo
    % LevelsNo(i,1) = i;          %LevelsNo contains SignalElementsNo corrospening level
    if isMidrise == 1       % No zero
        
        %%%%%%%%%%%%%% The Right Sound %%%%%%%%%%%%%%
        if i == 1   % intial value
            quantizedSignal(1,2) = 0.5*step;    % element voltage
            BitStream(1,2*R+1) = (L/2)+1;         % element level no
            BitStream(1,2*R+2) = quantizedSignal(1,2); % element level voltage
        elseif quantizedSignal(i-1,2) < y(i,2)
            quantizedSignal(i,2) = quantizedSignal(i-1,2) + step;
            BitStream(i,2*R+1) = BitStream(i-1,2*R+1)+1;
            BitStream(i,2*R+2) = quantizedSignal(i,2);
        elseif quantizedSignal(i-1,2) > y(i,2)
            quantizedSignal(i,2) = quantizedSignal(i-1,2) - step;
            BitStream(i,2*R+1) = BitStream(i-1,2*R+1)-1;
            BitStream(i,2*R+2) = quantizedSignal(i,2);
        elseif quantizedSignal(i-1,2) == y(i,2)
            quantizedSignal(i,2) = quantizedSignal(i-1,2);
            BitStream(i,2*R+1) = BitStream(i-1,2*R+1);
            BitStream(i,2*R+2) = quantizedSignal(i,2);
        end
        %%%%%%%%%%%%%% The left Sound %%%%%%%%%%%%%%
        if i == 1   % intial value
            quantizedSignal(1,3) = 0.5*step;    % element voltage
            BitStream(1,2*R+3) = (L/2)+1;         % element level no
            BitStream(1,2*R+4) = quantizedSignal(1,3); % element level voltage
        elseif quantizedSignal(i-1,3) < y(i,2)
            quantizedSignal(i,3) = quantizedSignal(i-1,3) + step;
            BitStream(i,2*R+3) = BitStream(i-1,2*R+3)+1;
            BitStream(i,2*R+4) = quantizedSignal(i,3);
        elseif quantizedSignal(i-1,3) > y(i,3)
            quantizedSignal(i,2) = quantizedSignal(i-1,3) - step;
            BitStream(i,2*R+3) = BitStream(i-1,2*R+3)-1;
            BitStream(i,2*R+4) = quantizedSignal(i,3);
        elseif quantizedSignal(i-1,3) == y(i,3)
            quantizedSignal(i,3) = quantizedSignal(i-1,3);
            BitStream(i,2*R+3) = BitStream(i-1,2*R+3);
            BitStream(i,2*R+4) = quantizedSignal(i,3);
        end
        
        
        %%%%%%%%%%%%%% The Right Sound %%%%%%%%%%%%%%
    else        % Mid-tread % with Zero
        if i == 1   % intial value
            quantizedSignal(1,2) = 0;       % element voltage
            BitStream(1,2*R+1) = L/2;         % element level no
            BitStream(1,2*R+2) = quantizedSignal(1,2);    % element level voltage
        elseif quantizedSignal(i-1,2) < y(i,2)
            quantizedSignal(i,2) = quantizedSignal(i-1,2) + step;
            BitStream(i,2*R+1) = BitStream(i-1,2*R+1)+1;
            BitStream(i,2*R+2) = quantizedSignal(i,2);
        elseif quantizedSignal(i-1,2) > y(i,2)
            quantizedSignal(i,2) = quantizedSignal(i-1,2) - step;
            BitStream(i,2*R+1) = BitStream(i-1,2*R+1)-1;
            BitStream(i,2*R+2) = quantizedSignal(i,2);
        elseif quantizedSignal(i-1,2) == y(i,2)
            quantizedSignal(i,2) = quantizedSignal(i-1,2);
            BitStream(i,2*R+1) = BitStream(i-1,2*R+1);
            BitStream(i,2*R+2) = quantizedSignal(i,2);
        end
        
        %%%%%%%%%%%%%% The left Sound %%%%%%%%%%%%%%
        if i == 1   % intial value
            quantizedSignal(1,3) = 0;       % element voltage
            BitStream(1,2*R+3) = L/2;         % element level no
            BitStream(1,2*R+4) = quantizedSignal(1,3);    % element level voltage
        elseif quantizedSignal(i-1,3) < y(i,3)
            quantizedSignal(i,3) = quantizedSignal(i-1,3) + step;
            BitStream(i,2*R+3) = BitStream(i-1,2*R+3)+1;
            BitStream(i,2*R+4) = quantizedSignal(i,3);
        elseif quantizedSignal(i-1,3) > y(i,3)
            quantizedSignal(i,3) = quantizedSignal(i-1,3) - step;
            BitStream(i,2*R+3) = BitStream(i-1,2*R+3)-1;
            BitStream(i,2*R+4) = quantizedSignal(i,3);
        elseif quantizedSignal(i-1,3) == y(i,3)
            quantizedSignal(i,3) = quantizedSignal(i-1,3);
            BitStream(i,2*R+3) = BitStream(i-1,2*R+3);
            BitStream(i,2*R+4) = quantizedSignal(i,3);
        end
    end
end

%% BitStreams
de2biInputRight = BitStream(:,2*R+1);
de2biInputLeft = BitStream(:,2*R+3);
disp(min(de2biInputRight)); disp(max(de2biInputRight));
disp(min(de2biInputLeft)); disp(max(de2biInputLeft));
BitStream(:,1:R) = de2bi(de2biInputRight,R,'left-msb'); %Right elements bit stream
BitStream(:,(R+1):(2*R)) = de2bi(de2biInputLeft,R,'left-msb'); %Left elements bit stream

%% Mean Square Quantization Error
MSQE(1:2) = (1/SignalElementsNo)*sum((y(:,2:3)-quantizedSignal(:,2:3)).^2);

%% ploting
%%%%%%%%%%%%%% The Right Sound %%%%%%%%%%%%%%
plot(y(:,1),y(:,2),'bo-');
hold on
stairs(quantizedSignal(:,1),quantizedSignal(:,2),'rx-')
xlabel('Time (s)'); ylabel('Voltage (V)');
legend('Signal','QuantizedSignal');
if isMidrise == 0
    title('Mid-tread uniform quantizer(Right Sound)')
else
    title('Mid-rise uniform quantizer(Right Sound)')
end
figure

%%%%%%%%%%%%%% The left Sound %%%%%%%%%%%%%%
plot(y(:,1),y(:,3),'bo-');
hold on
stairs(quantizedSignal(:,1),quantizedSignal(:,3),'rx-')
xlabel('Time (s)'); ylabel('Voltage (V)');
legend('Signal','QuantizedSignal');
if isMidrise == 0
    title('Mid-tread uniform quantizer(Left Sound)')
else
    title('Mid-rise uniform quantizer(Left Sound)')
end
figure

end



