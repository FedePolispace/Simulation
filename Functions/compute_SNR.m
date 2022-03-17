%Downlink (Satellite ---> Ground Station)
%   P_r = received power to ground station
%   P_n = noise power received by ground station
%   Pt = power transmitted from satellite 
%   Gt = satellite antenna gain
%   Gr = ground station antenna gain
%   R = distance between satellite and ground station (vector)
%   lambda = signal wavelenght downlink
%   Aatm = atmosphere loss
%   Aiono = ionosphere loss
%   Teq = system noise temp of the ground station

%Uplink (Ground Station ---> Satellite)
%   P_r = received power to satellite
%   P_n = noise power received by satellite
%   Pt = power transmitted from ground station 
%   Gt = ground station antenna gain
%   Gr = satellite antenna gain
%   R = distance between satellite and ground station (vector)
%   lambda = signal wavelenght uplink
%   Aatm = atmosphere loss
%   Aiono = ionosphere loss
%   Teq = system noise temp of the satellite

%P_r and P_n are in dB

%TO-DO
%   Hydrometeors
%   Spacecraft pointing lossesl1

function SNR = compute_SNR(Pt,Gt,Gr,R,lambda,Aatm,Aiono,Teq,B)
    SNR = computePr(Pt,Gt,Gr,R,lambda,Aatm,Aiono) - computePn(Teq,B);
end

function P_r = computePr(Pt,Gt,Gr,R,lambda,Aatm,Aiono)
    P_r = Pt + Gt + 0 + Gr - 20*log10((4*pi*R)./lambda) - Aatm - Aiono;
    %IMPORTANT!!
    %   The ratio (4*pi*R)/lambda should be updated when we are considering
    %   matrices as inputs (or scalar values):
    %   FOR MATRICES = (4*pi*R)./lambda
    %   FOR SCALAR VALUES = (4*pi*R)/lambda
end

function P_n = computePn(Teq,B)
    P_n = 10*log(physconst('Boltzmann')*Teq*B);
    %There is the log() function for the conversion to dB
end
