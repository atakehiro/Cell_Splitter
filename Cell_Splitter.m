% 2�l�摜(tif)�ƍזE�̏d�S���(csv)����A�Ȃ��������������o���āA�זE���Ƃɕ������ĕۑ�����
% 2�����E3�����̂ǂ���̉摜�ł��\
p_xy = 1; % miroco meter per pixel % �ʒu����pixel���ɒ������߂Ɏg�p
img2D_flag= 1; % 2�����摜�ł͂P
area_flg = 1; %area_id�ϐ�(area.mat�Ɋi�[�����)�����o����(�ŏ��͂P�ɂ���)
csv_filename = 'Results.csv'; %imageJ ��measure��result��z��A6����8��ڂ�,X,Y,Slice������悤�ɂ���
%% �֐��t�@�C���փp�X��ʂ�
addpath('function')
%% csv�t�@�C���̓ǂݎ��
data1 = readmatrix(csv_filename);
if size(data1, 2) < 7
    error('Error. CSV�t�@�C�����s�K�؂ł��B')
elseif size(data1, 2) < 8
    data1(:,8) = zeros(size(data1, 1),1);
end
data1 = data1(:,[6,7,8]);
%% tif�t�@�C���̓ǂݎ��
tic
[file, file_path] = uigetfile('*.tif');
file_info = imfinfo([file_path, file]);
d1 = file_info(1).Height;
d2 = file_info(1).Width;
T = numel(file_info);
bit = file_info(1).BitDepth;
  
IMG = zeros(d1,d2,T);
for t = 1:T
    IMG(:,:,t) = imread([file_path, file], t);
end
disp('�f�[�^�ǂݎ�芮��')
toc
if img2D_flag
    IMG = repmat(IMG, [1,1,2]);
    data1(:,3) = 1;
end
area = IMG > 0;
%% �Ȃ��������������o���āA�C���f�b�N�X��cell�ɕۑ�����i���Ԃ�������j
tic
disp('�Ȃ������̈�����o���܂�')
if area_flg > 0
    ind_list = find(area);
    i = 0;
    area_ind = {};
    while numel(ind_list) > 0
        [x,y,z] = ind2sub(size(area),ind_list(1));
        [ind, ~] = find_connected_space_3D(x,y,z,area);
        ind_list = setdiff(ind_list,ind);
        i = i + 1;
        area_ind(i) = {ind};
    end
    save('area.mat','area_ind')
end
toc
load('area.mat')
disp(['�̐�1voxel�ȏ�̗̈��', num2str(numel(area_ind)), '�ł��B'])

%% �d�S���܂܂��̈�݂̂�T��
gc_i = data1;
gc_i(:,1) = round(data1(:,2)./ p_xy); % matlab�̔z��ł́iy,x,z)�̏���(i,j,z)
tmp = gc_i(:,1);
tmp(tmp < 1) = 1;
tmp(tmp > size(area,1)) = size(area,1);
gc_i(:,1) = tmp;
gc_i(:,2) = round(data1(:,1)./ p_xy); % matlab�̔z��ł́iy,x,z)�̏���(i,j,z)
tmp = gc_i(:,2);
tmp(tmp < 1) = 1;
tmp(tmp > size(area,2)) = size(area,2);
gc_i(:,2) = tmp;
gc1_ind = sub2ind(size(area),gc_i(:,1),gc_i(:,2),gc_i(:,3));
gc_area = zeros(size(data1,1),numel(area_ind));
for i = 1:numel(area_ind)
    gc_area(:,i) = ismember(gc1_ind,area_ind{i});
end
[row,col] = find(gc_area);
disp(['�זE���܂񂾗̈��', num2str(numel(unique(col))), '�ł��B'])

disp('�[�[�[�[�[�[�[�[�̈敪����Ƃ��J�n�[�[�[�[�[�[�[�[')
%% �����ɍ����̈�݂̂����o���ĕۑ�
area_list = unique(col);
need_split = {};
not_split = {};
for i = 1:numel(area_list)
    gc_list = gc_i(row(col == area_list(i)),:);
    if size(gc_list,1) > 1
        need_split(end+1) = {{area_ind{area_list(i)},gc_list}};
    else
        not_split(end+1) = {{area_ind{area_list(i)},gc_list}};
    end
end
disp(['�������K�v�ȗ̈��', num2str(numel(need_split)), '�ł��B'])

while numel(need_split) > 0
    %% �ŒZ�����ɂ���d�S�y�A�����o��
    iid = need_split{1,1}{1,1};
    gcs = need_split{1,1}{1,2};
    need_split(1) = [];
    a = min(pdist(gcs));
    Z = squareform(pdist(gcs));
    [nest,~] = find(Z==a);
    Area = zeros(size(area));
    Area(iid) = 1;
    %% �ł��߂��d�S�����Ԍo�H���v�Z���A�@���ʂ̖ʐςōł��ׂ������Ő؂�i���Ԃ�������j
    % �P�̈悪���������܂ŌJ��Ԃ�
    sp_flag = 1;
    while sp_flag > 0
        try
            Area = find_cut_space(gcs, nest, Area);
        catch
            sp_flag = 0;
            disp('�o�H��������܂���B')
            disp('�����������܂����B���̕����Ɉڂ�܂��B')
        end
    end
    %% �Ȃ��������������o���āA�C���f�b�N�X��cell�ɕۑ�����
    disp('�Ȃ������̈�����o���܂�')
    ind_list = find(Area);
    i = 0;
    area_ind = {};
    while numel(ind_list) > 0
        [x,y,z] = ind2sub(size(Area),ind_list(1));
        [ind, ~] = find_connected_space_3D(x,y,z,Area);
        ind_list = setdiff(ind_list,ind);
        i = i + 1;
        area_ind(i) = {ind};
    end
    disp('���o������')
    %% �d�S���܂܂��̈�݂̂�T��
    gc_i = gcs;
    gc1_ind = sub2ind(size(area),gc_i(:,1),gc_i(:,2),gc_i(:,3)); % matlab�̔z��ł́iy,x,z)�̏���(i,j,z)
    gc_area = zeros(size(gcs,1),numel(area_ind));
    for i = 1:numel(area_ind)
        gc_area(:,i) = ismember(gc1_ind,area_ind{i});
    end
    [row,col] = find(gc_area);


    %% �����ɍ����̈�݂̂����o���ĕۑ�
    area_list = unique(col);
    for i = 1:numel(area_list)
        gc_list = gc_i(row(col == area_list(i)),:);
        if size(gc_list,1) > 1
            need_split(end+1) = {{area_ind{area_list(i)},gc_list}};
        else
            not_split(end+1) = {{area_ind{area_list(i)},gc_list}};
        end
    end
    disp(['�������K�v�ȗ̈��', num2str(numel(need_split)), '�ł��B'])
end
disp('�[�[�[�[�[�[�[�[�̈敪����ƏI���[�[�[�[�[�[�[�[')

%% �̈�ɔԍ��t������
S_IMG = zeros(size(IMG));
for i = 1:numel(not_split)
    ind = not_split{1,i}{1,1};
    S_IMG(ind) = i;
end

%% �ԍ��̐U�蒼��(�F���o���o���ɔz�u���邽��)
cn = max(S_IMG(:));
T_IMG = zeros(size(S_IMG));
p = randperm(cn);
for i = 1:cn
    T_IMG(S_IMG==i)=p(i);
end

%% ��������
bit = 16;
tic
T_IMG = cast(T_IMG,['uint',num2str(bit)]);
imwrite(T_IMG(:,:,1),[file_path, 'CELL_', file]);
for t = 2:T
    imwrite(T_IMG(:,:,t),[file_path, 'CELL_', file],'WriteMode','append');
end
disp('�������݊���')
toc

%% �֐�
function Area1 = find_cut_space(gcs, nest, Area)
    Start = gcs(nest(1),:);
    End = gcs(nest(2),:);
    ANS = find_shortest_path_6direction(Area, Start, End);
    [m, n, l] = ind2sub(size(Area), ANS.track);
    trace = [m', n', l'];
    area_space = zeros(size(trace,1)-1,1);
    for i = 1:size(trace,1)-1
        df = abs(trace(i+1,:) - trace(i,:));
        if df(1) > 0
            plane = Area(trace(i,1),:,:);
            points = [trace(i,2),trace(i,3)];
        elseif df(2) > 0
            plane = Area(:,trace(i,2),:);
            points = [trace(i,1),trace(i,3)];
        else
            plane = Area(:,:,trace(i,3));
            points = [trace(i,1),trace(i,2)];
        end
        f = find_connected_space(points(1), points(2), squeeze(plane));
        area_space(i) = sum(size(f,1)); % micro meter square
    end
    [~,ind] = min(area_space);
    df = abs(trace(ind+1,:) - trace(ind,:));
    if df(1) > 0
        plane = Area(trace(ind,1),:,:);
        points = [trace(ind,2),trace(ind,3)];
    elseif df(2) > 0
        plane = Area(:,trace(ind,2),:);
        points = [trace(ind,1),trace(ind,3)];
    else
        plane = Area(:,:,trace(ind,3));
        points = [trace(ind,1),trace(ind,2)];
    end
    f = find_connected_space(points(1), points(2), squeeze(plane));
    if df(1) > 0
        a = ones(size(f,1),1) .* trace(ind,1);
        A = [a,f(:,1),f(:,2)];
    elseif df(2) > 0
        a = ones(size(f,1),1) .* trace(ind,2);
        A = [f(:,1),a,f(:,2)];
    else
        a = ones(size(f,1),1) .* trace(ind,3);
        A = [f(:,1),f(:,2),a];
    end
    Area1 = Area;
    Area1(sub2ind(size(Area), A(:,1), A(:,2), A(:,3))) = 0;
    % �}��
    figure
    subplot(2,2,1)
        scatter3(m,n,l,10)
        hold on
        scatter3(trace(ind,1),trace(ind,2),trace(ind,3),10)
        hold on
        scatter3(Start(1), Start(2), Start(3), 100, 'd', 'MarkerFaceColor', 'k')
        hold on
        scatter3(End(1), End(2), End(3), 100, 'd', 'MarkerFaceColor', 'k')
        xl = xlim;
        yl = ylim;
        zl = zlim;
        title('���S�����񂾐�')
    subplot(2,2,2)
        [m, n, l] = ind2sub(size(Area), find(Area1));
        scatter3(m,n,l,10)
        hold on
        scatter3(A(:,1),A(:,2),A(:,3),10)
        hold on
        scatter3(Start(1), Start(2), Start(3), 100, 'd', 'MarkerFaceColor', 'k')
        hold on
        scatter3(End(1), End(2), End(3), 100, 'd', 'MarkerFaceColor', 'k')
        xlim(xl)
        ylim(yl)
        zlim(zl)
        title('�J�b�g�����̈�')
    subplot(2,2,3)
        plot(area_space)
        hold on
        xline(ind, '--r');
        title('�f�ʐς̕ω�')
    subplot(2,2,4)
        plane = squeeze(plane);
        plane(f(:,1),f(:,2))= 2;
        imagesc(plane)
        colorbar
        axis ij
        title('�f��')
end
