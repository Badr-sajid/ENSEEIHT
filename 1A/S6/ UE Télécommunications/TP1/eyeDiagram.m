function eyeDiagram(x,Ns)
    plot(reshape(x,2*Ns,length(x)/2/Ns));
    axis([1,2*Ns,-max(abs(x))-0.5,max(abs(x))+0.5]);
end

