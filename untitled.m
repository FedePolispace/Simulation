
%Preallocation of array
var = cell(height(Satellite_positions_table),4);
m=1;

for i=1:height(GS_array.observations.Var1)
   for j=1:height(Satellite_positions_table)
       %If the difference is less than 25 seconds
       if(abs(datenum(Satellite_positions_table.Date(j))-datenum(GS_array.observations.Var1(i)))<=2.8935e-04)
            var{m,1}=GS_array.observations.Var1(i);
            var{m,2}=Satellite_positions_table.Satellite_X(j);
            var{m,3}=Satellite_positions_table.Satellite_Y(j);
            var{m,4}=Satellite_positions_table.Satellite_Z(j);           
            m=m+1;
       end
   end
end

clear i j m;





%vector@t = interp1([t1right; t2right], [vector values@t1right; vectorvalues@t2right], timeiwant)