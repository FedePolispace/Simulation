classdef Telecom_parameters    
    properties
        SNR
        BER
        PER
        DTR
        HPW
    end
    
    methods
        function obj = Telecom_parameters(SNR,BER,PER,DTR,HPW)
            obj.SNR=SNR;
            obj.BER=BER;
            obj.PER=PER;
            obj.DTR=DTR;
            obj.HPW=HPW;
        end
    end
end

