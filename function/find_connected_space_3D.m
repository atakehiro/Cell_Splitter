function [ind, Land] = find_connected_space_3D(x,y,z,matrix_3d)
%指定した場所につながる、非ゼロの場所を探して返す関数
%入力はテンソルの開始番号ｘ,ｙ,ｚと探す領域となるテンソルmatrix_3d
list = [x,y,z];
[lim_x, lim_y, lim_z] = size(matrix_3d);
Land = zeros(lim_x, lim_y, lim_z);

while isempty(list) < 1
    pos = list(1,:);
    list(1,:) = [];
    if matrix_3d(pos(1),pos(2),pos(3)) > 0
        Land(pos(1),pos(2),pos(3)) = 1;
        
        if pos(1) > 1
            a = pos - [1, 0, 0];
            if Land(a(1),a(2),a(3)) < 1
                list = [list;a];
            end
        end
        if pos(1) < lim_x
            a = pos + [1, 0, 0];
            if Land(a(1),a(2),a(3)) < 1
                list = [list;a];
            end
        end
        
        if pos(2) > 1
            a = pos - [0, 1, 0];
            if Land(a(1),a(2),a(3)) < 1 
                list = [list;a];
            end
        end
        if pos(2) < lim_y
            a = pos + [0, 1, 0];
            if Land(a(1),a(2),a(3)) < 1
                list = [list;a];
            end
        end   
        
        if pos(3) > 1
            a = pos - [0, 0, 1];
            if Land(a(1),a(2),a(3)) < 1 
                list = [list;a];
            end
        end
        if pos(3) < lim_z
            a = pos + [0, 0, 1];
            if Land(a(1),a(2),a(3)) < 1
                list = [list;a];
            end
        end
    else
        Land(pos(1),pos(2),pos(3)) = nan;
    end
    
    list = unique(list,'rows');
    
end
Land(isnan(Land))=0;
ind = find(Land);
%[m,n,l] = ind2sub( size(matrix_3d),ind);
%f = [m,n,l];
end