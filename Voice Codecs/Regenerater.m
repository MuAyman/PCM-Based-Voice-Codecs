function [A_regen]=Regenerater(A,R, Decision,Ap)
if (max (A)~=0)
    A=A./abs(max(A));
end
switch Decision
    case 1 %unipoler
        A_decoded=A;
        for i=1:length(A)
            if    ((abs(A(i)-1))<(abs(A(i)-0)))
                A_regen(i)=1*Ap;
            else
                A_regen(i)=0;
            end
        end
     
    case 0 %polar
        for i=1:length(A)
            if    (abs(A(i)-1)<abs(A(i)+1))
                A_regen(i)=Ap*1;
            else
                A_regen(i)=-1*Ap;
            end
        
        end
end
%%%%% convert from bits to values%%%
%%e=length(A)/R;
L=length(A)/R;
B=reshape(A_regen,[R,L]);
B=transpose(B);
end