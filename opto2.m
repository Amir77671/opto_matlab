
%% define sampling frequency, time vector and signal vector
f= 1000;      % 1k Hz signal frequency
fs = f*2;   % sampling frequency - engineer nyquest of signal frequency
dt = 1/fs;    % time between consecutive samples
t = 0:dt:2;   % time vector


n_vec = randn(size(t));  % gaussian white noise
%n_vec=rand(size(t))-0.5; % non-gaussian white noise
lowAmp =1 ;
highAmp =100;
yt_low  =@(t) n_vec + lowAmp*sin(2*pi*t*f);      % lowAmp sig with noise
yt_high=@(t)  n_vec + highAmp*sin(2*pi*t*f);      % HighAmp sig with noise
%plotting signal
figure(1)
plot(t,yt_high(t));
figure(2);
plot(t,yt_low(t));

%getting pdf
mu = 0;
sigma = 1;
y_pdf = pdf('Normal',yt(t),1,1);
figure(3)
plot(t,y_pdf);






%% Lowpass filtering:
% y = conv(y,ones(30,1),'same');  % undo remark for a convolution with a rect (sinc filtering)

%% bandpass filtering:
f0=2000;
BW=400;
% y=bandpass_filter(y,dt,f0,BW);

%% compute spectrum, autocorrelation 
ac = xcorr(y,y,'unbiased');
ac_time_vec = (1:length(ac))*dt;
ac_time_vec = ac_time_vec-mean(ac_time_vec);
[S,fvec] = pspectrum(y,fs);

y = y-mean(y);  %clean or not to clean ?

%% plots
figure
subplot(4,1,1);
plot(t,y);
title('raw signal');
xlabel('time (s)')
ylabel('amp (e.g. Volts)')

% histogram analysis
subplot(4,1,2);
hist(y,100);
title('amplitude histogram');
xlabel('amplitude');
ylabel('probability density');

disp('press any key to continue');
pause 

% spectral analysis
subplot(4,1,3);
loglog(fvec,S(:,1));
xlabel('frequency (Hz)');
title('Power spectral density')
ylim([1e-4 2]*max(S(19:end)));
xlim([100 fs/2]) 
grid on
ylabel('V^2/Hz');

set(gcf,'position',[1 84 1024 707])


disp('press any key to continue');
pause 


subplot(4,1,4);
plot(ac_time_vec/1e-3,ac/max(ac),'.-')
title('normalized autocorrelation');
xlabel('time (msec)')
xlim([-400 400]*dt/1e-3);
ylim([-1 1]);
grid on