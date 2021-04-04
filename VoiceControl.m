fs = 16e3;
n = 8;
channels = 1;
recorder = audiorecorder(fs,n,channels);
s = serialport('COM6', 9600);


tic
while toc <= 60
    recordblocking(recorder,1);
    y = getaudiodata(recorder);
    if max(y) > 0.01
        auditorySpect = helperExtractAuditoryFeatures(y,fs);
        command = classify(trainedNet,auditorySpect);
        if command == "go"
            disp("go");
            val = 1;
            write(s, val, "uint8");
        elseif command == "stop"
            disp("stop");
            val = 0;
            write(s, val, "uint8");
        end
    end
end

%%% Serial Comm %%%
write(s, 0, "uint8");
delete(s)
