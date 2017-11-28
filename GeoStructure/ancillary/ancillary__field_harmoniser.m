function [ template_struct, candidate_struct ] = ancillary__field_harmoniser(template_struct, candidate_struct)


% Harmonises fields between a struct sample and a candidate struct

if(isempty(fieldnames(candidate_struct)))
    field_names = fieldnames(template_struct);
    for fi = 1:length(field_names)
        [candidate_struct(:).(field_names{fi})] = [];
    end
end


disp('Execution complete. Function ancillary__field_harmoniser.m terminating.');
end