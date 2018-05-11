%[F,V] = stlread('femur.stl')
tic
V=[1.1 2.3 9.1; 4.3 5.5 9.4; 2.9 1 9.7; 6.3 7.7 9.9; 2 3 7.5; 6 7 4; 7 7.1 4];
z=9:-1:1; %planes and intervals of cut
f=1; %counter for projected values
co=1;%counter for colored grids
zx=zeros(10000,2);
patch=zeros(10000,3); %preallocation of matrix saves time of calculation as
color=zeros(10000,2);%it doesnt have to copy values to new matrix everytime
pointer=zeros(1,10000);%gives range of pointds in a plane, 1-5 1st plane, 5-9 2nd
minValue = min([V(:,1);V(:,2)]); %define limits of grids based on vertices
maxValue = max([V(:,1);V(:,2)]); %of CAD, can also be taken as stock size
for j=1:length(z) %traversing all planes
p=f; 
for i= 1:length(V(:,1)) %traversing all points
if (V(i,3)>z(j))
patch(f,:)=[V(i,1), V(i,2), z(j)]; %projection on z plane
f=f+1;
else continue
end
end
Gridstart = round(minValue)-1; %formation of grid
Gridend = round(maxValue)+1;
gx = .2; %grid width
gy = .2;
gridx = Gridstart:gx:Gridend;
gridy = Gridstart:gy:Gridend;
[xg,yg]=meshgrid(gridx,gridy);
zg = z(j)/1*(0*xg + 0*yg +1); %plane of grid
c=xg*0+yg*0+50; %color of grid
surf(xg,yg,zg,c)
colormap(hsv) %color library for pallette hsv
hold on %hold the graph for next points to be plotted
for ii= p:f-1 %read points of patch
for ij= 1:length(gridx)-1 %read all x grids
if patch(ii,1)< xg(1,ij+1) && patch(ii,1) >= xg(1,ij) %locate x value of points in grids
    for jj=1:length(gridy)-1 %read all y grids
        if patch(ii,2)< yg(jj+1,1) && patch(ii,2 ) >= yg(jj,1) %locate y value of points in grids
            color(co,:)= [xg(1,ij), yg(jj,1)]; %save the selected grid point
             xgg=[xg(1,ij),xg(1,ij+1); xg(1,ij), xg(1,ij+1)]; %form grid of 2x2 matix
             ygg=[yg(jj,1), yg(jj,1);yg(jj+1,1),yg(jj+1,1)];
             zgg=z(j)+xgg*0+ygg*0;
             colormap autumn %color according to z value of the grids
             surf(xgg,ygg,zgg);
             hold on
%             zx(co,1)=z(j)+xg(1,ij)*0+ yg(jj,1)*0;%try to plot
%             plot3(color(:,1),color(:,2),zx(:,1),'ro')
            co=co+1;
        end
    end
end
end
end
pointer(j)=p;
end
toc
%now move tool over grid points which are not colored that is not in 
%unmachined matrix using optimisation technique like travelling salesman problem
%end