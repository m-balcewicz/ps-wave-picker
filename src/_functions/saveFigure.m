function saveFigure(fig, filename)
    funcDir = fileparts(mfilename('fullpath'));
    projectRoot = fileparts(fileparts(funcDir));
    filepath = fullfile(projectRoot, 'figures', filename);
    exportgraphics(fig, filepath, 'Resolution', 300);
end