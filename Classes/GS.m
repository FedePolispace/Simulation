classdef GS

    properties
        name
        latitude
        longitude
        elevation
        observations
        observations_interval_matrix
        telecom_parameters_matrix
    end
    
    methods
        function obj = GS(name,latitude,longitude,elevation,observations,observations_interval_matrix,telecom_parameters_matrix)
            obj.name = name;
            obj.latitude = latitude;
            obj.longitude = longitude;
            obj.elevation = elevation;
            obj.observations = observations;
            obj.observations_interval_matrix = observations_interval_matrix;
            obj.telecom_parameters_matrix=telecom_parameters_matrix;
        end
    end
end

