N = 2^6;
h_pn = commsrc.pn('GenPoly', [6 5 0], 'InitialStates', [0 0 0 0 0 1], 'NumBitsOut', N);
syncronization_bits = generate(h_pn);

%% Reading data file and using root raised cosine filter with roll off value as 0.75

samplesPerSymbol = 8; % Samples per symbol
RX_ss_tmp = csvread('received_9_7.csv',0,0); % Acquired data at the NI using LabView (RFSA acquired)
RX_ss = complex(RX_ss_tmp(:,1), RX_ss_tmp(:,2)); % Received data having two column (I and Q) converting into complex

%Filtering received signal using root raised cosing filter with rollof factor as 0.75
FIR_coeff75 = Hps75.Numerator;
XX_signal = conv(FIR_coeff75, RX_ss);
RX_signal = XX_signal/max([real(XX_signal);imag(XX_signal)]);


%% EYE Diagram
eye_len = samplesPerSymbol;
eye_frame_len=floor(length(RX_signal)/eye_len);
I_eye=zeros(eye_len,eye_frame_len);
Q_eye=zeros(eye_len,eye_frame_len);

for i=1:eye_frame_len
    I_eye(:,i)= real(RX_signal((i-1)*eye_len+1:i*eye_len,1));
    Q_eye(:,i)=imag(RX_signal((i-1)*eye_len+1:i*eye_len,1));
end





%% Sampling Instant Ientification
eye_var=zeros(eye_len,1);
for i=1:eye_frame_len
    for j=1:eye_len
        eye_var(j,1)=eye_var(j,1)+I_eye(j,i)^2;
    end
end
eye_var=eye_var/eye_frame_len;
[~,eye_offset]=max(eye_var(1:samplesPerSymbol));

%% Downsampling of the filtered signal by 8 at the best sampling instant
Symbols=zeros(floor(length(RX_signal)/samplesPerSymbol),1);
for i=1:length(Symbols)-1
    Symbols(i,1)=RX_signal((i-1)*samplesPerSymbol+eye_offset,1);
end

%% Implementation of phase and frequency correction(PLL/Costas loop) for demodulation
K1_PLL =0.0313;
K2_PLL =2.49e-4;
unwrap_phi_array = zeros(size(Symbols));
phi_array = zeros(size(Symbols));
freq_array = zeros(size(Symbols));
filt_phi_array = zeros(size(Symbols));
filt_freq_array = zeros(size(Symbols));
phi_array(1:2)=atan(imag(Symbols(1:2))./real(Symbols(1:2)));
unwrap_phi_array(1:2)=phi_array(1:2);
for i=3:length(Symbols)
    phi=atan(imag(Symbols(i))/real(Symbols(i)));
    phi1(i)=phi;
    old_phi=phi_array(i-1);
    if (phi-old_phi < -pi/2)
        freq = pi+phi-old_phi;
    elseif (phi-old_phi > pi/2)
        freq = -pi+phi-old_phi;
    else
        freq = phi-old_phi;
    end
    freq_array(i)=freq;
    unwrap_phi_array(i)=unwrap_phi_array(i-1)+freq;
    phi_array(i)=phi;
    filt_phi_array(i) = (2-K1_PLL-K2_PLL)*filt_phi_array(i-1) ...
        -(1-K1_PLL)*filt_phi_array(i-2) ...
        +(K1_PLL+K2_PLL)*unwrap_phi_array(i-1) ...
        -(K1_PLL)*unwrap_phi_array(i-2);
    Symbols(i) = Symbols(i)*complex(cos(filt_phi_array(i)),-sin(filt_phi_array(i)));


end



%~~~~~~~~~Finding the starting bit and detect the bits (Works in good SNR)~~~~~~~~~~~~~~~~~~~~~~~%
bits_rec_bipolar=sign(real(Symbols));
corval=zeros(length(bits_rec_bipolar),1);

%% Correlation value to get starting index
%~~~~~~~~~~~~~~~ Using syncronization bit finding stating start of the data packet~~~~~~~~~~~~~~~%
for i=1:(length(bits_rec_bipolar)-64) %subtracting 64 to prevent overflow when iterating through bits_rec_bipolar
    corval(i,1)=sum(syncronization_bits(1:64).*bits_rec_bipolar(i:i+63));
end

[peak,start_bit_ind]=max(abs(corval)); %searching maximum correlation value and its index number
start_bit_ind
peak

ss=sign(corval(start_bit_ind));       % required to correct the polarity of PLL output
bits_rec=(ss*bits_rec_bipolar+1)/2;   %converting 1--->1 and -1---->0

len1 = bits_rec(start_bit_ind + 64 : start_bit_ind + 80);
len = string(len1);

sLen = "";
for i=1:length(len)-1
    sLen = sLen + len(i);
end
len = bin2dec(sLen);


detected_bits = bits_rec(start_bit_ind:start_bit_ind + 79 + len); % chopping out high correlted length

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Saving the binary data to a text ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
bin_to_text = detected_bits;
bin_to_text = bin_to_text(81:end);
bin_to_text;
bin_str=sprintf('%d',bin_to_text)
 %Open the file for writing
fid = fopen('text_to_string.txt', 'w');

%Print the string variable to the file
fprintf(fid, '%s', regexprep(bin_str, '\s', ''));


