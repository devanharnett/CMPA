% Devan Harnett
% 100998173 

% PA 8: Diode Parameter Extraction 

% Part 1
Is = 0.01e-12;
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1; 

V = linspace(-1.95,0.7,200);
L = length(V); 
I = zeros(1,L); 

Ir = -0.1 + (0.2).*rand(1,L);
Ivar = zeros(1,L);

% fill I vectors 
for k =1:200
    I(k) = Is*(exp((1.2/.025)*V(k))-1)+(Gp*V(k))-(Ib*exp(-(1.2/0.025)*(V(k) +Vb)-1)); 
    Ivar(k) = I(k)+Ir(k); 
    
end

figure(1)
plot(V,Ivar)
hold on 
semilogy(V,I)
xlabel 'Voltage (V)' 
ylabel 'Current (pA)' 

% Part 2
PI4 = polyfit(V,I,4);
PI8 = polyfit(V,I,8);

Y4 = polyval(PI4,V);
Y8 = polyval(PI8,V);

figure(2) 
plot(V,I)
hold on 
plot(V,Y4)
plot(V,Y8)
title 'Part 2: Poly Fit'
xlabel 'Voltage (V)'
ylabel 'Current (pA)'

figure(3) 
semilogy(V,abs(I))
hold on 
semilogy(V,abs(Y4))
semilogy(V,abs(Y8))
title 'Part 2: Poly Fit'
xlabel 'Voltage (V)'
ylabel 'Current (pA)'

% Part 3: Non Linear curve fitting 
I = I';
V = V';
%first case 
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
FO2 = fit(V,I,fo2);
If1 = FO2(V);

%Second Case 
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)');
FO2 = fit(V,I,fo2);
If2 = FO2(V);

%Third Case 
fo3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)');
FO3 = fit(V,I,fo3);
If3 = FO3(V);

figure(4) 
plot(V,If1)
hold on
plot(V,If2)
plot(V,If3)
legend('If1','If2','If3')

figure(5)
semilogy(V,abs(If1))
hold on 
semilogy(V,abs(If2))
semilogy(V,abs(If3))
legend('If1','If2','If3')

% Part 4: Neutral Net 

inputs = V.';
targets = I.';
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net);
Inn = outputs;

figure(6)
plot(V,Inn)
hold on 
plot(V,I)
title 'Neural Fit'

figure(7)
semilogy(V,abs(Inn))
hold on 
semilogy(V,abs(I))
title 'Neural Fit SemiLog'




