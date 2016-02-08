figure('Name','Simulink Animation')
OS=OS_xyz.data;
SC=SC_xyz;

for time = 1:10:size(OS,3)
    %magnets
    scatter3([OS(:,1,time);SC(:,1)],...
        [OS(:,2,time);SC(:,2)],...
        [OS(:,3,time);SC(:,3)],100,[0.5,0.5,0.5],'filled');
    daspect([1 1 1])
    drawnow
end
