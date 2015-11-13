vocoderParams = genLPCCoeffs;
[aud_rcv lpcstim_rcv] = vocoderSynth3(vocoderParams);
soundsc(aud_rcv,vocoderParams.fs)