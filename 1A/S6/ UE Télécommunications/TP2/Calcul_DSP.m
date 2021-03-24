function [DSP,freq] = Calcul_DSP(x)
    NFFT = 2^(nextpow2(length(x))+2);
    DSP = 1/length(x)*(abs(fft(x,NFFT)).^2);
    freq = linspace(-1/4,1/4,NFFT);
end