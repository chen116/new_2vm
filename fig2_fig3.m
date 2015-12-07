%% individual figures: Schedulability of Jobs
%individual figures: jobs suc/fail
%figure 1 -> bimo but with task long period (not used in paper becuase it is long period)
%figure 2 -> figure 2(b) Schedulability of Jobs (Heavy Distribution)
%figure 3 -> figure 3(a) Schedulability of Jobs (Medium Distribution)
%figure 4 -> figure 3(b) Schedulability of Jobs (Light Distribution)

close all
clc
clear

% make sure they have same length in char counts
% gives vm folder names
vms = cellstr([
               'rtxen-40-20-myapp-4hours-run2';
               'xen-40-20-myapp-4hours-run   ';
               'kvm-485-1-4.2                ']);
dists = cellstr(['bimo-medium_uni-moderate_ratio    ';...
                 'uni-heavy_uni-moderate_ratio      ';...
                 'uni-medium_uni-moderate_ratio     ';...
                 'uni-light_uni-moderate_ratio      ';...
                 ]);
file_dists = cellstr(['bimo-moderate-jobs ';...
                      'heavy-moderate-jobs';...
                      'mediu-moderate-jobs';...
                      'light-moderate-jobs';...
                 ]);
% distributions on x-axis
xaxis=[0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.2 4.4 4.6 4.8 5 5.2 5.4 5.6 5.8 6 6.2 6.4 6.6 6.8 7 7.2 7.4 7.6 7.8 8 8.2 8.4];
xaxis=[1 2 3 4 4.2];
dists_title = cellstr(['Bimodal Task Utilization [0.66%:(0.001,0.1), 0.33%:(0.5, 0.9)]';
                       'Heavy Task Utilization (0.5, 0.9)                             ';
                       'Medium Task Utilization (0.1, 0.4)                            ';
                       'Light Task Utilization (0.001, 0.1)                           ']);


% line, maker style
lw=[10,6,4,3];
ms=[12,10,8,6];
ls=cellstr(['-ob';'-xg';'-xm';'-^k']);


%figure
for j=1:length(dists)

    schdublilty=[];
    h = figure
    % h=figure('position', [0, 0, 1275, 400])
    for i=1:length(vms)

       fid = fopen(strcat(strtrim(vms{i}),'/',dists{j}));

        tline = fgets(fid);
        suc = zeros(1,length(xaxis));
        sum = zeros(1,length(xaxis));
        util = 1;

        while ischar(tline)

            if(1==(isspace(tline)))
                util=util+1;

            elseif(ischar(tline))

                oline = strsplit(strtrim(tline));
                if (size(oline,2)>2)
                    sum(util)=sum(util)+str2double(oline(2));
                    suc(util)=suc(util)+str2double(oline(1));

                end
            end
            tline = fgets(fid);
        end
        fclose(fid);

        schdublilty(i,:) = (suc./sum)';
        plot(xaxis,schdublilty(i,:),ls{i},'LineWidth',lw(i),'MarkerSize',ms(i))
        ylim([0 1.1])
        h_legend=legend('Xen-RTDS', 'Xen-credit','KVM','Bare-Metal','Location','sw');
        set(h_legend,'FontSize',15);
        set(gca,'fontsize',15)
        xlabel('Normalized Task Set Utilization','FontSize',15)
        ylabel('Fraction of Schedulable Jobs','FontSize',15)
        grid on
        hold on
        

    end
    
    % save to pdf
    [ax4,h3]=suplabel(strtrim(dists_title{j}),'t');
    set(h3,'FontSize',20)  
    set(h,'Units','Inches');
    pos = get(h,'Position');
    %set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3)-2.8, pos(4)])
    set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
    print(h,strtrim(file_dists{j}),'-dpdf','-r0')
   
end


