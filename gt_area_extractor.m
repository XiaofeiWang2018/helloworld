clear all;
% 生成医生标注的边缘、bbox和其中的每一个像素
fileFolder=fullfile('./gt_area_label');
dirOutput=dir(fullfile(fileFolder,'*.txt'));%如果存在不同类型的文件，用‘*’读取所有，如果读取特定类型文件，'.'加上文件类型，例如用‘.jpg’
fileNames1={dirOutput.name};
fileFolder=fullfile('./image');
dirOutput=dir(fullfile(fileFolder,'*.jpg'));%如果存在不同类型的文件，用‘*’读取所有，如果读取特定类型文件，'.'加上文件类型，例如用‘.jpg’
fileNames2={dirOutput.name};
N=20; % num of pics
samecolor=0;%每种病的颜色固定；或者根据四种病种分配不同颜色
sameimage=1; %每张图片只显示一种病，或者四种病分布在四张图片上
if(samecolor && sameimage)
    for i=1:N
        
        Len=length(fileNames1{1,i});
        
        %% 得到txt文件的行数,得到每一行的数据
        [lines,tline]=read_txt(strcat('./gt_area_label/',fileNames1{1,i}));
        
        part=tline(1,1);
        part_point=zeros(1,str2num(part));
        count_point=-1; %构成一个区域的点的个数
        count_part=1; %区域的个数
        %% 得到每个区域的点数
        for j=2:lines
            count_point=count_point+1;
            if tline(j,2)=='a'
                part_point(1,count_part)=count_point;
                count_point=-1;
                count_part=count_part+1;
            end
        end
        
        %% 画出每个区域并保存-画框
       
        h=imshow(strcat('./image/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4))),'.jpg'));
        init=2;
        for j=1:str2num(part) %每一个区域
            x=zeros(1,part_point(j));
            y=zeros(1,part_point(j));
            if j>1
                init=init+part_point(j-1)+1;
            end
            
            for k=init:init+part_point(j)-1
                count=1;
                while tline(k,count)~=' '
                    count=count+1;
                end
                x(1,k-init+1)=str2num(tline(k,1:count-1));
                y(1,k-init+1)=str2num(tline(k,count+1:length(tline(k,:))));
            end
%             x_judge=250;
%             y_judge=250;
%             judge=inpolygon(x_judge,y_judge,x,y);
%             plot(x,y,x_judge(judge),y_judge(judge),'.r',x_judge(~judge),y_judge(~judge),'.b')
%             
            x1=zeros(1,part_point(j)-1);
            x2=zeros(1,part_point(j)-1);
            y1=zeros(1,part_point(j)-1);
            y2=zeros(1,part_point(j)-1);
            for k=1:part_point(j)-1 %每一个区域内的每一对坐标
                x1=x(1,k);
                y1=y(1,k);
                x2=x(1,k+1);
                y2=y(1,k+1);
                if k==part_point(j)-1
                    x2=x(1,1);
                    y2=y(1,1);
                end
                line([x1,x2],[y1,y2],'linewidth',2,'color','r'); %画线
            end
            f = getframe(gcf);
            imwrite(f.cdata, strcat('./gt_area_plot/samecolor_sameimage/',num2str(i),'.jpg'));
            
        end
        close;
    end
end
if(samecolor && ~sameimage)
    for i=1:N
        Len=length(fileNames1{1,i});
        if exist(strcat('./gt_area_plot/difcolor_difimage/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4)))),'dir')==0
            mkdir('./gt_area_plot/difcolor_difimage/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4))));
        end
        
        %% 得到txt文件的行数,得到每一行的数据
        [lines,tline]=read_txt(strcat('./gt_area_label/',fileNames1{1,i}));
        part=tline(1,1);
        part_point=zeros(1,str2num(part));
        count_point=-1; %构成一个区域的点的个数
        count_part=1; %区域的个数
        part_num=zeros(1,str2num(part));
        %% 得到每个区域的点数
        for j=2:lines
            count_point=count_point+1;
            if tline(j,2)=='a'
                part_num(1,count_part)=str2num(tline(j,1));
                part_point(1,count_part)=count_point;
                count_point=-1;
                count_part=count_part+1;
            end
        end
        
        %% 画出每个区域并保存-画框
        
        pathno_part=zeros(1,4);
        for m=1:str2num(part)
            if part_num(1,m)==1
                pathno_part(1,1)=pathno_part(1,1)+1;
            end
            if part_num(1,m)==2
                pathno_part(1,2)=pathno_part(1,2)+1;
            end
            if part_num(1,m)==3
                pathno_part(1,3)=pathno_part(1,3)+1;
            end
            if part_num(1,m)==4
                pathno_part(1,4)=pathno_part(1,4)+1;
            end
            
        end
        for L=1:4
            if pathno_part(1,L)
                if L==1
                   [lines,tline]=read_txt(strcat('./sorting/RNFLD/',fileNames1{1,i})); 
                end
                if L==2
                   [lines,tline]=read_txt(strcat('./sorting/Disc_loss/',fileNames1{1,i})); 
                end
                if L==3
                   [lines,tline]=read_txt(strcat('./sorting/Disc_hemorrhage/',fileNames1{1,i})); 
                end
                if L==4
                   [lines,tline]=read_txt(strcat('./sorting/BETA/',fileNames1{1,i})); 
                end  
                part=pathno_part(1,L);
                part_point=zeros(1,part);
                count_point=-1; %构成一个区域的点的个数
                count_part=1; %区域的个数
  
                
                for j=1:lines
                    count_point=count_point+1;
                    if tline(j,1)=='a'
                        part_point(1,count_part)=count_point;
                        count_point=-1;
                        count_part=count_part+1;
                    end
                end
                h=imshow(strcat('./image/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4))),'.jpg'));
                init=1;
                for j=1:pathno_part(1,L) %每一个区域
                    
                    x=zeros(1,part_point(j));
                    y=zeros(1,part_point(j));
                    if j>1
                        init=init+part_point(j-1)+1;
                    end
                    
                    for k=init:init+part_point(j)-1
                        count=1;
                        while tline(k,count)~=' '
                            count=count+1;
                        end
                        x(1,k-init+1)=str2num(tline(k,1:count-1));
                        y(1,k-init+1)=str2num(tline(k,count+1:length(tline(k,:))));
                    end
                    
                    x1=zeros(1,part_point(j)-1);
                    x2=zeros(1,part_point(j)-1);
                    y1=zeros(1,part_point(j)-1);
                    y2=zeros(1,part_point(j)-1);
                    for k=1:part_point(j)-1 %每一个区域内的每一对坐标
                        x1=x(1,k);
                        y1=y(1,k);
                        x2=x(1,k+1);
                        y2=y(1,k+1);
                        if k==part_point(j)-1
                            x2=x(1,1);
                            y2=y(1,1);
                        end
                        line([x1,x2],[y1,y2],'linewidth',2,'color','r'); %画线
                    end
                    
                end
                f = getframe(gcf);
                    if L==1
                        imwrite(f.cdata, strcat('./gt_area_plot/samecolor_difimage/',num2str(i),'/',num2str(i),'_RNFLD.jpg'));
                        close;
                    end
                    if L==2
                        imwrite(f.cdata, strcat('./gt_area_plot/samecolor_difimage/',num2str(i),'/',num2str(i),'_DL.jpg'));
                        close;
                    end
                    if L==3
                        imwrite(f.cdata, strcat('./gt_area_plot/samecolor_difimage/',num2str(i),'/',num2str(i),'_DH.jpg'));
                        close;
                    end
                    if L==4
                        imwrite(f.cdata, strcat('./gt_area_plot/samecolor_difimage/',num2str(i),'/',num2str(i),'_BETA.jpg'));
                        close;
                    end
            end
        end
    end
end

if(~samecolor && sameimage)
     for i=1:N
        Len=length(fileNames1{1,i});
        
        %% 得到txt文件的行数,得到每一行的数据
        [lines,tline]=read_txt(strcat('./gt_area_label/',fileNames1{1,i}));
        part=tline(1,1);
        part_point=zeros(1,str2num(part));
        count_point=-1; %构成一个区域的点的个数
        count_part=1; %区域的个数
        part_num=zeros(1,str2num(part));
        %% 得到每个区域的点数
        for j=2:lines
            count_point=count_point+1;
            if tline(j,2)=='a'
                part_num(1,count_part)=str2num(tline(j,1));
                part_point(1,count_part)=count_point;
                count_point=-1;
                count_part=count_part+1;
            end
        end
        
        %% 画出每个区域并保存-画框
        
        pathno_part=zeros(1,4);
        for m=1:str2num(part)
            if part_num(1,m)==1
                pathno_part(1,1)=pathno_part(1,1)+1;
            end
            if part_num(1,m)==2
                pathno_part(1,2)=pathno_part(1,2)+1;
            end
            if part_num(1,m)==3
                pathno_part(1,3)=pathno_part(1,3)+1;
            end
            if part_num(1,m)==4
                pathno_part(1,4)=pathno_part(1,4)+1;
            end
            
        end
        set (gcf,'Position',[0,0,500,500]);
        h=imshow(strcat('./image/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4))),'.jpg'),'border','tight','initialmagnification','fit');
        for L=1:4
           
            if pathno_part(1,L)
                if L==1
                   [lines,tline]=read_txt(strcat('./sorting/RNFLD/',fileNames1{1,i})); 
                end
                if L==2
                   [lines,tline]=read_txt(strcat('./sorting/Disc_loss/',fileNames1{1,i})); 
                end
                if L==3
                   [lines,tline]=read_txt(strcat('./sorting/Disc_hemorrhage/',fileNames1{1,i})); 
                end
                if L==4
                   [lines,tline]=read_txt(strcat('./sorting/BETA/',fileNames1{1,i})); 
                end  
                part=pathno_part(1,L);
                part_point=zeros(1,part);
                count_point=-1; %构成一个区域的点的个数
                count_part=1; %区域的个数
  
                
                for j=1:lines
                    count_point=count_point+1;
                    if tline(j,1)=='a'
                        part_point(1,count_part)=count_point;
                        count_point=-1;
                        count_part=count_part+1;
                    end
                end
                
                init=1;
                for j=1:pathno_part(1,L) %每一个区域
                    
                    x=zeros(1,part_point(j));
                    y=zeros(1,part_point(j));
                    if j>1
                        init=init+part_point(j-1)+1;
                    end
                    
                    for k=init:init+part_point(j)-1
                        count=1;
                        while tline(k,count)~=' '
                            count=count+1;
                        end
                        x(1,k-init+1)=str2num(tline(k,1:count-1));
                        y(1,k-init+1)=str2num(tline(k,count+1:length(tline(k,:))));
                    end
                    
                    x1=zeros(1,part_point(j)-1);
                    x2=zeros(1,part_point(j)-1);
                    y1=zeros(1,part_point(j)-1);
                    y2=zeros(1,part_point(j)-1);
                    for k=1:part_point(j)-1 %每一个区域内的每一对坐标
                        x1=x(1,k);
                        y1=y(1,k);
                        x2=x(1,k+1);
                        y2=y(1,k+1);
                        if k==part_point(j)-1
                            x2=x(1,1);
                            y2=y(1,1);
                        end
                        if L==1
                            line([x1,x2],[y1,y2],'linewidth',2,'color','g'); %画线
                        end
                        if L==2
                            line([x1,x2],[y1,y2],'linewidth',2,'color','r'); %画线
                        end
                        if L==3
                            line([x1,x2],[y1,y2],'linewidth',2,'color','b'); %画线
                        end
                        if L==4
                            line([x1,x2],[y1,y2],'linewidth',2,'color','y'); %画线
                        end
                    end
                    
                end
                
                f = getframe(gcf);  
                
                imwrite(f.cdata, strcat('./gt_area_plot/difcolor_sameimage/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4))),'.jpg')); 
            end
        end
        close;
    end
end
if(~samecolor && ~sameimage)
    for i=1:N
        Len=length(fileNames1{1,i});
        if exist(strcat('./gt_area_plot/difcolor_difimage/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4)))),'dir')==0
            mkdir('./gt_area_plot/difcolor_difimage/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4))));
        end
        
        %% 得到txt文件的行数,得到每一行的数据
        [lines,tline]=read_txt(strcat('./gt_area_label/',fileNames1{1,i}));
        part=tline(1,1);
        part_point=zeros(1,str2num(part));
        count_point=-1; %构成一个区域的点的个数
        count_part=1; %区域的个数
        part_num=zeros(1,str2num(part));
        %% 得到每个区域的点数
        for j=2:lines
            count_point=count_point+1;
            if tline(j,2)=='a'
                part_num(1,count_part)=str2num(tline(j,1));
                part_point(1,count_part)=count_point;
                count_point=-1;
                count_part=count_part+1;
            end
        end
        
        %% 画出每个区域并保存-画框
        
        pathno_part=zeros(1,4);
        for m=1:str2num(part)
            if part_num(1,m)==1
                pathno_part(1,1)=pathno_part(1,1)+1;
            end
            if part_num(1,m)==2
                pathno_part(1,2)=pathno_part(1,2)+1;
            end
            if part_num(1,m)==3
                pathno_part(1,3)=pathno_part(1,3)+1;
            end
            if part_num(1,m)==4
                pathno_part(1,4)=pathno_part(1,4)+1;
            end
            
        end
        for L=1:4
            if pathno_part(1,L)
                if L==1
                   [lines,tline]=read_txt(strcat('./sorting/RNFLD/',fileNames1{1,i})); 
                end
                if L==2
                   [lines,tline]=read_txt(strcat('./sorting/Disc_loss/',fileNames1{1,i})); 
                end
                if L==3
                   [lines,tline]=read_txt(strcat('./sorting/Disc_hemorrhage/',fileNames1{1,i})); 
                end
                if L==4
                   [lines,tline]=read_txt(strcat('./sorting/BETA/',fileNames1{1,i})); 
                end  
                part=pathno_part(1,L);
                part_point=zeros(1,part);
                count_point=-1; %构成一个区域的点的个数
                count_part=1; %区域的个数
  
                
                for j=1:lines
                    count_point=count_point+1;
                    if tline(j,1)=='a'
                        part_point(1,count_part)=count_point;
                        count_point=-1;
                        count_part=count_part+1;
                    end
                end
                h=imshow(strcat('./image/',num2str(str2num(fileNames1{1,i}(Len-6:Len-4))),'.jpg'));
                init=1;
                for j=1:pathno_part(1,L) %每一个区域
                    
                    x=zeros(1,part_point(j));
                    y=zeros(1,part_point(j));
                    if j>1
                        init=init+part_point(j-1)+1;
                    end
                    
                    for k=init:init+part_point(j)-1
                        count=1;
                        while tline(k,count)~=' '
                            count=count+1;
                        end
                        x(1,k-init+1)=str2num(tline(k,1:count-1));
                        a=length(tline(k,:));
                        b=tline(k,count+1:length(tline(k,:)));
                        y(1,k-init+1)=str2num(tline(k,count+1:length(tline(k,:))));
                    end
                    
                    x1=zeros(1,part_point(j)-1);
                    x2=zeros(1,part_point(j)-1);
                    y1=zeros(1,part_point(j)-1);
                    y2=zeros(1,part_point(j)-1);
                    for k=1:part_point(j)-1 %每一个区域内的每一对坐标
                        x1=x(1,k);
                        y1=y(1,k);
                        x2=x(1,k+1);
                        y2=y(1,k+1);
                        if k==part_point(j)-1
                            x2=x(1,1);
                            y2=y(1,1);
                        end
                        if L==1
                            line([x1,x2],[y1,y2],'linewidth',2,'color','g'); %画线
                        end
                        if L==2
                            line([x1,x2],[y1,y2],'linewidth',2,'color','r'); %画线
                        end
                        if L==3
                            line([x1,x2],[y1,y2],'linewidth',2,'color','b'); %画线
                        end
                        if L==4
                            line([x1,x2],[y1,y2],'linewidth',2,'color','y'); %画线
                        end
                    end
                    
                end
                f = getframe(gcf);
                    if L==1
                        imwrite(f.cdata, strcat('./gt_area_plot/difcolor_difimage/',num2str(i),'/',num2str(i),'_RNFLD.jpg'));
                        close;
                    end
                    if L==2
                        imwrite(f.cdata, strcat('./gt_area_plot/difcolor_difimage/',num2str(i),'/',num2str(i),'_DL.jpg'));
                        close;
                    end
                    if L==3
                        imwrite(f.cdata, strcat('./gt_area_plot/difcolor_difimage/',num2str(i),'/',num2str(i),'_DH.jpg'));
                        close;
                    end
                    if L==4
                        imwrite(f.cdata, strcat('./gt_area_plot/difcolor_difimage/',num2str(i),'/',num2str(i),'_BETA.jpg'));
                        close;
                    end
            end
        end
    end
end