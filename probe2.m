%function [template, mask] = probe2()
% !!!!!!!!
% need modified
% !!!!!!!!
maindir = 'C:\Users\gban\Desktop\iriscode\LG2200-2010-04-27_29\2010-04-27_29';    % dir for probe2 -  LG2200 as probes
subdir = dir( maindir);

maindirG = 'C:\Users\gban\Desktop\iriscode\LG2200-2008-03-11_13\2008-03-11_13';    % dir for gallary -  LG2200 as gallary
subdirG = dir( maindirG);
flag = 1;

imposter=[];
genuine =[];

%probe subfolder
for i = 1 : length(subdir)
    
    if( isequal( subdir( i ).name, '.' ) || ...
        isequal( subdir( i ).name, '..' ) || ...
        ~subdir( i ).isdir )   
        continue;
    end
    %gallary subfolder
    for j = 1 : length(subdirG)
        
        if( isequal( subdirG( j ).name, '.' ) || ...
            isequal( subdirG( j ).name, '..' ) || ...
            ~subdirG( j ).isdir )   
            continue;
        end
        
        % iterator tiff for probe
        subdirpath2 = fullfile( maindir, subdir( i ).name, '*.tiff' );
        images = dir( subdirpath2 ); 
        
        % iterator tiff for gallary
        subdirpathG = fullfile( maindirG, subdirG( j ).name, '*.tiff' );
        imagesG = dir( subdirpathG ); 
        
        %genuine
        if subdir( i ).name == subdirG( j ).name
            % get probe image
            for m = 1 : length( images )
            imagepath = fullfile( maindir, subdir( i ).name, images( m ).name);
            [newtemplate, newmask] = createiristemplate(imagepath);
                % get gallary image
                for n = 1 : length( imagesG )
                     imagepathG = fullfile( maindirG, subdirG( i ).name, imagesG( n ).name);
                     %
                     %  caculate
                     %
                     [newtemplateG, newmaskG] = createiristemplate(imagepathG);
                     tempResult = gethammingdistance(newtemplate, newmask, newtemplateG, newmaskG, 15);
                     
                     %
                     %  result
                     %
                     genuine = [genuine tempResult];
                     
                end
            % get gallary image
            %template{flag} = newtemplate;
            %mask{flag} = newmask;

            %flag=flag+1;
        
                
            end
        else
            % get probe image
            for m = 1 : length( images )
            imagepath = fullfile( maindir, subdir( i ).name, images( m ).name);
            [newtemplate, newmask] = createiristemplate(imagepath);
                % get gallary image
                for n = 1 : length( imagesG )
                     imagepathG = fullfile( maindirG, subdirG( j ).name, imagesG( n ).name);
                     %
                     %  caculate
                     %
                     [newtemplateG, newmaskG] = createiristemplate(imagepathG);
                     tempResult = gethammingdistance(newtemplate, newmask, newtemplateG, newmaskG, 15);
                     
                     %
                     %  result
                     %
                     imposter = [imposter tempResult];
                     
                end
            end
        end
    end
    
            
    %subdirpath = fullfile( maindir, subdir(i).name, '*.txt');
    
    % read txt
    % txt = dir(subdirpath);
    % ffid = fopen(txt,'r');
    
% 
%      
%         tempTemplate = zeros(length( images ));
%         tempMask = zeros(length( images )); 
%         for k = 1 : length( images )
%             imagepath = fullfile( maindir, subdir( i ).name, images( k ).name);
%             [newtemplate, newmask] = createiristemplate(imagepath);
% 
%             template{flag} = newtemplate;
%             mask{flag} = newmask;
% 
%             flag=flag+1;
%         end



end

a = genuine;
b = imposter;

% Histograms
h1 = histfit(a,40,'normal')
hold on;
h2 = histfit(b,40,'normal')

% Curves
lines = findobj('Type','Line')
set(lines(1),'Color','r')
set(lines(2),'Color','g')


patch=findobj(gca,'Type','patch');
set(patch(1),'FaceColor',[0 .5 .5],'EdgeColor','w')

hold off;

% Legends
legend1 = sprintf('Genuine');
legend2 = sprintf('Imposter');
legend({legend1, legend2});
