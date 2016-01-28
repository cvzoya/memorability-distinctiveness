function PublishizePlot(h,FigureSize)
% get current figure if not provided
if nargin==0
    h = gcf();
end

set(h,'Color',[1 1 1])
childAxes = get(h,'Children');
for i = 1:length(childAxes)
    a = childAxes(i);
    
    set(0,'DefaultAxesFontName', 'Times');
    set(0,'DefaultTextFontname', 'Times')
    
    % set line widths and axis fonts
    set(a,'FontSize',16,'LineWidth',1);
    
    % if axis is legend, handle seprately
    if (strcmp(get(a,'Tag'),'legend'))
        set(a,'FontSize',12);
    else
        % otherwise, set properties for axes
        set(a, ...
          'Box'         , 'off'     , ...
          'TickDir'     , 'out'     , ...
          'TickLength'  , [.02 .02] , ...
          'XMinorTick'  , 'on'      , ...
          'YMinorTick'  , 'on'      , ...
          'XColor'      , [.2 .2 .2], ...
          'YColor'      , [.2 .2 .2], ...
          'LineWidth'   , 1         );
      
      % if not an image, turn on grid
      if (~strcmp(get(a,'Type'),'image'))
%          set(a,   'YGrid'       , 'on'      );
      end
    end
    % get title
    titleHandle = get(a,'Title');
    if (titleHandle)
        set(titleHandle,'FontSize',20,'FontWeight','bold');%,'Interpreter','LaTeX');
    end
    
    xlabelHandle = get(a,'XLabel');
    if (xlabelHandle)
        set(xlabelHandle,'FontSize',20);%,'Interpreter','LaTeX');
    end
    
    ylabelHandle = get(a,'YLabel');
    if (ylabelHandle)
        set(ylabelHandle,'FontSize',20);%,'Interpreter','LaTeX');
    end
    
    zlabelHandle = get(a,'ZLabel');
    if (zlabelHandle)
        set(zlabelHandle,'FontSize',20,'Interpreter','LaTeX');
    end
    
    plotHandles = get(a,'Children');
    k = 1;
    for k = 1:length(plotHandles)
        plotHandle = plotHandles(k);
       if (strcmp(get(plotHandle,'Type'),'line'))
            set(plotHandle,'LineWidth',2);
            set(plotHandle,'MarkerSize',25);
        end
    end
end

if exist('FigureSize')
    set(gcf,'Units','centimeters ')
    set(gcf,'Position',[0 0 FigureSize]);
    set(gcf, 'PaperUnits', 'centimeters');
    set(gcf, 'PaperSize', FigureSize);
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperPosition', [0.1 0.1 FigureSize-0.1]);
    set(gca,'OuterPosition',[0.05 0.05*FigureSize(1)/FigureSize(2) 0.95 1-0.05*FigureSize(1)/FigureSize(2)]);
end

