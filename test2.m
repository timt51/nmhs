gsyns = 11;
C_Ameans = zeros(1,gsyns);
C_Bmeans = zeros(1,gsyns);

for i = 1:gsyns
    n1gsyn = 0.1*(i-1);
    numCases = 10;
    C_As = zeros(1,numCases);
    C_Bs = zeros(1,numCases);
    logLss = zeros(1,numCases);

    for j = 1:numCases
        disp(gsyns*(i-1)+j);
        [C_A, C_B, logLs] = nmhs2D(n1gsyn,.5);
        C_As(j) = max(C_A);
        C_Bs(j) = max(C_B);
        logLss(j) = logLs;
    end
    
    C_Ameans(i) = mean(C_As);
    C_Bmeans(i) = mean(C_Bs);
end

%plot(n1gsyns, C_Ameans, n1gsyns, C_Bmeans); axis([0 1 0 1]); xlabel('n1gsyn (n2gsyn = 0 always)'); ylabel('Connectivity'); legend('n3 listens to n1', 'n3 listens to n2'); title('n1 Excites n3, n2 Does Not');