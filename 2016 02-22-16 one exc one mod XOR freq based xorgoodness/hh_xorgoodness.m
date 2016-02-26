% Leif Gibb 2/22/16

function xorgoodness = hh_xorgoodness(xor_in, instfreq)

xorfrac = sum(xor_in.*instfreq)/sum(xor_in);
notxorfrac = sum(~xor_in.*instfreq)/sum(~xor_in);
xorgoodness = 2*xorfrac/(xorfrac+notxorfrac)-1;

end