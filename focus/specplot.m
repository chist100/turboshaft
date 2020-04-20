function [] = specplot(sig, Fs)
    N = length(sig);
    Pyy = abs(fft(sig, N));
    f = Fs * (0:round(N/2)-1)/N;
    figure
    plot(f(1:round(N/2)), 20*log10(Pyy(1:round(N/2))))
end