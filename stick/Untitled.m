for i=1:100
    plot([Back(i,1), Shoulder(i,1), Elbow(i,1), Wrist(i,1), MCP(i,1), Toe(i,1)], [Back(i,2), Shoulder(i,2), Elbow(i,2), Wrist(i,2), MCP(i,2), Toe(i,2)]);
    hold on
end