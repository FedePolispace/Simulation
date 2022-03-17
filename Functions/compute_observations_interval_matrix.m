function observations_interval_matrix = compute_observations_interval_matrix( ...
    number_of_points, ...
    starting_date_array, ...
    end_date_array)

    x = linspace(0,1,number_of_points);
    observations_interval_matrix = starting_date_array + x.*(end_date_array - starting_date_array);
end

