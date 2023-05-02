
N=2^6; % Number of bits = 64
%% text to binary
fid = fopen('encode_9_7_haardik.txt');
    x=fread(fid,'*char');
    disp(length(x))
    binary = dec2bin(x,1);   % The number of bits is taken as 1 since the text is already in binary format
    disp(binary)
    binary_t=transpose(x);
    txt_to_bin=binary_t(:)-'0';
%disp(length(txt_to_bin))
    
%% adding syncronization bits
h_pn=commsrc.pn('GenPoly',[6 5 0],'InitialStates',[0 0 0 0 0 1],'NumBitsOut',N);
syncronization_bits=generate(h_pn);
messageLength = dec2bin(length(txt_to_bin), 16);  %defining message length
messageLengthTransposed = transpose(messageLength);
text_to_bin_messageLength = messageLengthTransposed(:) - '0';


%% [sync bits, message length, data bits]
tx_text = [syncronization_bits; text_to_bin_messageLength; txt_to_bin];
%disp(length(tx_text))
%disp(length(text_to_bin_messageLength))

%% Bit Sequence to Signal (Upsampling by 8)
bits_I = 2*(tx_text - 0.5);
sig_ipt_I = upsample(bits_I, 8);
FIR_coeff75 = Hps75.Numerator;
sig_RRC75_I = conv(FIR_coeff75,sig_ipt_I);
sig_RRC75_I = sig_RRC75_I/max(sig_RRC75_I);
disp(length(sig_RRC75_I))
csvwrite('Initial_9_7_haardik.csv',tx_text);
csvwrite('Transmit_9_7_haardik.csv',sig_RRC75_I);
