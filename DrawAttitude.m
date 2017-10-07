%%
 %2014.7.19 �� sky.zhou ��д
 function DrawAttitude(pitch,roll,yaw)
%%
%������ʾ�ɻ���̬������Ϊpitch��roll��yaw��
 %�Լ���2B�㷨���̫���ˣ����ո�ȥ�����������÷������Ұ�
 mode = 2       %��������ַ������м��㣬1����ʾ���Լ�д��2B�㷨���м��㣬2��ʾ�÷������Ҿ�����м���
   
 %pitch = 60;
 %roll = 45;
 %yaw = 35;
 r1 =3;        %��Բ�뾶
 r2 = 0.618*r1;    %СԲ�뾶
  
 if mode == 2
     pitch = -pitch;   %�Ƕȶ��岻һ������һ��
     roll = -roll;     %�Ƕȶ��巽ʽ��һ�����Լ�ϰ�߸ľͺã�����ϣ�����������ķ���ת
 end
 dc = [cosd(yaw)*cosd(pitch)-sind(yaw)*sind(roll)*sind(pitch)   sind(yaw)*cosd(pitch)+cosd(yaw)*sind(roll)*sind(pitch)   cosd(roll)*(-sind(pitch));
       sind(yaw)*(-cosd(roll))                          cosd(yaw)*cosd(roll)                            sind(roll)        ;
       cosd(yaw)*sind(pitch)+sind(yaw)*sind(roll)*cosd(pitch)   sind(yaw)*sind(pitch)-cosd(yaw)*sind(roll)*cosd(pitch)      cosd(roll)*cosd(pitch) ]
 %�����ι�Լ��AΪ���㣬B CΪ���ߵĽǣ����巽λ����
 %       A
 %     B   C
 t_fpa = 35;      %�����ζ���Ƕ�����Ϊ40�ȣ�fpa On behalf of Fixed point angle
 t_b = (180 - t_fpa) / 2;
 t_c = t_b;
  
 if t_fpa > asind((r2/r1))*2
     t_fpa = asind((r2/r1))*2
 end
  
 %xd,yd,zd���������ֵ�������xyz���ֿ���
 %Լ�� xd yd zd �� 1 2 3 4λ�ֱ����������ABC�� A��B��A��C����
 if mode == 2
    xd=[3 -1.2735;3 -1.2735];
    yd=[0  1.3474;0  -1.3474];
    zd=[0 0;0 0];
    %���漸����ʼ���ĵ��Ǹ��� ����ġ�
    %pitch = 0;
    %roll = 0;
    %yaw = 0;
    %r1 =3;        %��Բ�뾶
    %r2 = 0.618*r1;    %СԲ�뾶
 else
    xd=[];
    yd=[];
    zd=[];
    tempA =[];     %�����м����Ƕȣ�Ŀǰ֮���������BOA
 end
    temp = [];
 if mode == 2
    temp = [xd(1,1) yd(1,1) zd(1,1);
            xd(1,2) yd(1,2) zd(1,2);
            xd(2,2) yd(2,2) zd(2,2)];
    temp = temp*dc;
    xd = [temp(1:2,1)';temp(1,1),temp(3,1)]
    yd = [temp(1:2,2)';temp(1,2),temp(3,2)]
    zd = [temp(1:2,3)';temp(1,3),temp(3,3)]
    %����λ�ã��������Ҿ����Ѿ�������ϣ�����ֱ���ú���ĺ���������ʾ
 end
  
 if mode == 1      %ִ���Լ���2B�㷨
 %xs ys zs�ֱ��ʼ�¼���̵Ľ� xs Ϊsysm��д
 syms x y z r xs ys zs;                                      %x y z ��������ϵ��������������rΪxOyƽ���еĴ�Բ��СԲ�뾶
 %��������������Ų���
 syms xa ya za xb yb zb za zb zc ;
  
 %%
 c1 = sym('x^2+y^2 = r^2');                         %��Բ����
 c1 = subs(c1,'r',r1)                               %����ʵ����ֵ
  
 c2 = sym('x^2+y^2 = r^2');                         %У԰���̣����Ա��Ϊ��c2 = 'x^2+y^2 = r^2'��Ч����һ����
 c2 = subs(c2,'r',r2)
  
 l1 = sym('cosd(yaw)*y=sind(yaw)*x')
 %l1 = sym('y=tand(yaw)*x')                         %���������ʽ����Ϊ�����ʽ����㣬90��-90�޷�ʹ��
 %l1 = subs(l1, 'yaw', yaw)                         %����ʵ����ֵ,���ﲻҪת��ʵ����ֵ��Ϊ�˷���subs������
 %%
 [xs ys] = solve(c1,l1,'x','y')                     %ע�⣬�����������xd yd�Ƿ��ű�����matlab�Զ�ת���ˣ��������¶��丳ֵ�����Ա����ֵ����
   
 %˫�ٷֺŻ����������ڷ�������ã�ͦ�á�
 temp = subs([xs;ys])
  
 %%
 %����A������
 if yaw > -90 && yaw < 90                             %�жϽǶȵķ�Χ������ѡ���������������εĶ����������Ǹ�
     %��������е�����⣬�Ƕ�ȷ���ˣ��Ϳ���֪��������x�����������ǰ������ֵ��ȡ��Ӧ��X���Ȼ��ȡ��Ӧ��Y�Ľ�
     temp = temp([temp(1:2)>0;temp(1:2)>0])
 elseif yaw == -90
     temp = [ 0 ;temp(temp<0)]
 elseif yaw == 90
     temp = [ 0 ;temp(temp>0)]
 else
     temp = temp([temp(1:2)<0;temp(1:2)<0])
 end
  
 %�õ���XOYƽ���������ζ���ĵ�һ����
 xd = [xd temp(1)]
 yd = [yd temp(2)]
  
 %%
 %����B������
  
 %temp���������ʾ���� AB�εĳ��ȣ�
 %       A
 %       O
 %    B  D  C
 %���� sind(t_b/2)*r2 ��ʾ����OD�εĳ��ȣ�cosd(t_b/2)*r2��BD�εĳ��ȣ�
 %temp��������ս����AB�ĳ���
 %���������α����������ҳɱ�����������
 %   AB     BC          A0                B0
 % ----- = -----       -----     =   ---------
 % sin(C)  sin(A)     sin(��ABO)      sin(��OAB)��ps:A��һ�룩
 %   ���������ABO��Ȼ��ͨ���ڽǺͿ��������AOB
 %   AB                BO         
 % -----       =     --------      �������AB���ȣ��򻯴�������    
 % sin(��AOB)        sin(��OAB)    
 % (180 - asind((r1/r2)*sind(t_fpa/2)) - (t_fpa/2)) Ϊ��BOA�Ĵ�С
 tempA = sym('(180 - asind((r1/r2)*sind(t_fpa/2)) - (t_fpa/2))');
 temp = sym('(r2/sind(t_fpa/2))*sind(tempA)');
 tempA = subs(tempA);
 temp = subs(temp);
  
  
 %temp = subs(sym('sqrt(((sind(t_b/2)*r2)+r1)^2 + (cosd(t_b/2)*r2)^2)'));
  
 %���� ���� xa ya Ϊ A�������,x,yΪҪ���B������
 temp = subs(sym('(x-xa)^2 + (y-ya)^2 = temp^2'),'temp',temp);
 %��xa��ya������ֵxa��ya��Ƕ�׻���
 temp = subs(subs(temp,'xa',xd(1)),'ya',yd(1))
 [xs ys] = solve(temp,c2,'x','y')    
  
 %ͨ������ļ�����Ѿ����Եõ� B C��������
 temp = subs([xs;ys])
  
 %������Ҫ�����������ĸ�����A���ĸ�����B��
 %%
 %    ��������xOyƽ���ڵ���ת
 %    B  
 %    D  O  A       yaw=0�ȵ�ʱ����������X0Yƽ��ķ�λ������ˮƽλ��Ϊx����ֱ����ΪY��
 %    C
 %    ȡһ����DB����һ���ķ�������n��0��1��
 %    ����ת����������������ͬ����ת
 %    ��Ϊn��OBΪ��ǣ���OBΪ�۽ǣ�so��n��OB���Ϊ��������OC���Ϊ�������Ӷ����ֳ�B���C��
 %%
 %    Ϊ�˱���rollΪ90�ȵ�ʱ����֮ǰ�Ķ��巽������n=��0��0�������ֲ�����B��C�㣬�����÷������Ҿ�����м���
 %�������Ҿ�����
 %dc = [cosd(yaw)*cosd(pitch)-sind(yaw)*sind(roll)*sind(pitch)   sind(yaw)*cosd(pitch)+cosd(yaw)*sind(roll)*sind(pitch)   cosd(roll)*(-sind(pitch));
 %      sind(yaw)*(-cosd(roll))                          cosd(yaw)*cosd(roll)                            sind(roll)        ;
 %      cosd(yaw)*sind(pitch)+sind(yaw)*sind(roll)*cosd(pitch)   sind(yaw)*sind(pitch)-cosd(yaw)*sind(roll)*cosd(pitch)      cosd(roll)*cosd(pitch) ]
 %%�㵽�����ʱ���ҷ���ֻҪ��xOyƽ���ڽ������εĳ�ʼ������ABC������������÷������Ҿ�����Ϳ����ˣ�Ȼ����10���Ӳ�����ʱ���ʵ����
 %�������ﻹ�Ǿ������������д�ꡣ���������ᡣ��������������������������������
 %%
 n  = [0  1  0]                                         %��������
 n  = n*dc                                               %�Է�������������ת
 %Լ�� xd yd zd �� 1 2 3 4λ�ֱ����������ABC�� A��B��A��C����
 n = n*[temp(1);temp(3);0]
 if n > 0       %˵���н�����ǣ��ý���B��
     xd = [ xd temp(1) xd temp(2)]
     yd = [ yd temp(3) yd temp(4)]
 else
     xd = [ xd temp(2) xd temp(1)]
     yd = [ yd temp(4) yd temp(3)]
 end
  
 %����ɱ�ɾ�����ʽ
 xd = [xd(1:2);xd(3:4)]
 yd = [yd(1:2);yd(3:4)]
  
 %������pitch�Ƕȵ�ʱ��X��������ӡ����
 xd = xd.*cosd(pitch)
 yd = yd.*cosd(pitch)
  
  
 %%
 %Լ�� xd yd zd �� 1 2 3 4λ�ֱ����������ABC�� A��B��A��C����
 %����z��A�����꣬����B��C����ȵ�
 zd = [zd sind(pitch)*r1]
  
 %����OD�ĳ��ȣ�Ȼ����Լ����B��C��Z���ϵ�����,Ҳ����D�������
 od = (sind(tempA - 90)*r2)
 %zd = [zd temp;zd temp]
  
 %����roll״̬��B��C������
 %          A
 %       E  O  F
 %     B    D    C
 %    �ȼ�����roll��OF�ĳ��ȣ�Ȼ����F��Z��ĸ߶ȣ�Ȼ��ȱȺ���B��C��Z��ĸ߶�
 %�������OF�ĳ���
 l2 = tand(t_fpa/2)*r1
 %�������F��Z���ϵı仯�߶�
 l2 = sind(roll)*l2
 %�������C����Z���ϵı仯�߶�,ͨ�����������μ���
 l2 = l2*(r1+od)/r1
  
 zd = [zd -l2;zd l2]
 %x,y�����picth�Ƕ�����
 yd(:,2) = yd(:,2).*cosd(roll)
 xd(:,2) = xd(:,2).*cosd(roll)
  
 %����ⷽ��д���������ᡣ���������������Ƿ������Һá�������Ԫ����ѧ������������
  
  
 end
 surf(xd,yd,zd)
 axis([-3 3 -3 3 -3 3])
 xlabel('X')
 ylabel('Y')
 zlabel('Z')
 text(xd(1,1),yd(1,1),zd(1,1),'A��')
 text(xd(1,2),yd(1,2),zd(1,2),'B��')
 text(xd(2,2),yd(2,2),zd(2,2),'C��')
 %%
 %������Բ
 hold on
 alpha=0:pi/20:2*pi;
 x=r1*cos(alpha);
 y=r1*sin(alpha);
 plot(x,y);
  
 hold on
 x=r2*cos(alpha);
 y=r2*sin(alpha);
 plot(x,y);
  
 hold off
 end