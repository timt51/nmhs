% Hodgkin-Huxley circuit model implemented by Leif Gibb 6/28/15 through 12/26/15

function ydot = hh_ode_new(t,y,Nneur,Nsyn,time,Iin,gsyn)

    ENa = 115;
    EK = -12;
    EL = 10.6;
    gNa = 120;
    gK = 36;
    gL = 0.3;
    C = 1;
    Tmax = 1.5;
    Vp = 2;
    Kp = 5;
    Erev = 0;
    alphasyn = [0.1 0.1];
    betasyn = [0.01 0.01];
    alphamod = [0.01 0.01];
    betamod = [1 1];
    SumIk = zeros(Nneur,1);
    u = zeros(Nneur,1);
    udot = zeros(Nneur,1);
    alphan = zeros(Nneur,1);
    alpham = zeros(Nneur,1);
    alphah = zeros(Nneur,1);
    betan = zeros(Nneur,1);
    betam = zeros(Nneur,1);
    betah = zeros(Nneur,1);
    m = zeros(Nneur,1);
    mdot = zeros(Nneur,1);
    n = zeros(Nneur,1);
    ndot = zeros(Nneur,1);
    h = zeros(Nneur,1);
    hdot = zeros(Nneur,1);
    T = zeros(Nsyn,1);
    r = zeros(Nsyn,1);
    rmod = zeros(Nsyn,1);
    rdot = zeros(Nsyn,1);
    rmoddot = zeros(Nsyn,1);
    
    for i = 1:Nneur
        u(i) = y(4*(i-1)+1);
        m(i) = y(4*(i-1)+2);
        n(i) = y(4*(i-1)+3);
        h(i) = y(4*(i-1)+4);
    end
    
    Vpre = [u(1) u(2)] - 70;
    Vpost = u(3) - 70;
    for j = 1:Nsyn
        T(j) = Tmax/(1+exp(-(Vpre(j)-Vp)/Kp));
        r(j) = y(4*Nneur + j);
        rmod(j) = y(4*Nneur + Nsyn + j);
        rdot(j) = alphasyn(j)*T(j)*(1-r(j)) - betasyn(j)*r(j);
        rmoddot(j) = alphamod(j)*(1-rmod(j)) - betamod(j)*T(j)*rmod(j);
    end
    Isyn(1) = gsyn*r(1)*rmod(2)*(Vpost-Erev);
    Isyn(2) = gsyn*r(2)*rmod(1)*(Vpost-Erev);
    
    for i = 1:Nneur
        
        SumIk(i) = gNa*m(i).^3*h(i)*(u(i)-ENa) + gK*n(i).^4*(u(i)-EK) + gL*(u(i)-EL);
        
        if i == 3
            SumIk(i) = sum([SumIk(i) Isyn]);
        end
        
        udot(i) = (-SumIk(i) + interp1(time,Iin(i,:),t))/C;
        alphan(i) = (0.1-0.01*u(i))/(exp(1-0.1*u(i))-1);
        alpham(i) = (2.5-0.1*u(i))/(exp(2.5-0.1*u(i))-1);       
        alphah(i) = 0.07*exp(-u(i)/20);
        betan(i) = 0.125*exp(-u(i)/80);
        betam(i) = 4*exp(-u(i)/18);
        betah(i) = 1/(exp(3-0.1*u(i))+1);
        mdot(i) = alpham(i)*(1-m(i)) - betam(i)*m(i);
        ndot(i) = alphan(i)*(1-n(i)) - betan(i)*n(i);
        hdot(i) = alphah(i)*(1-h(i)) - betah(i)*h(i);
        
    end
    
    ydot = [udot(1); mdot(1); ndot(1); hdot(1); udot(2); mdot(2); ndot(2); hdot(2); udot(3); mdot(3); ndot(3); hdot(3); rdot(1); rdot(2); rmoddot(1); rmoddot(2)];
    
end