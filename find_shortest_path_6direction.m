function ASTAR = find_shortest_path_6direction(Area, Start, End)
tic
disp('2“_‚ðŒ‹‚Ôü‚ð’Tõ‚µ‚Ü‚·B')
%% greedyƒAƒ‹ƒSƒŠƒYƒ€‚Å’Tõ (A*‚ðŠÈ—ª‰»)
List1.pos = Start;
List1.g = 0;
List1.f = List1.g + norm(End - Start);
List1.track = sub2ind(size(Area),List1.pos(1),List1.pos(2),List1.pos(3)); %List1.pos(1) + size(matrix,1) * List1.pos(2);
flag = 1;
MAP = Area;
while flag > 0
    S = struct2table(List1);
    [~, i] = min(S.f);
    pos = List1(i).pos;
    pG = List1(i).g;
    ptrack = List1(i).track;
    List1(i) = [];
    if pos(1) == End(1) && pos(2) == End(2) && pos(3) == End(3)
        ASTAR.g = pG;
        ASTAR.track = ptrack;
        flag = 0;
    end
    if pos(1) > 1
        A.pos = [pos(1) - 1, pos(2), pos(3)];
        [List1, MAP] = decide_A(A, List1, MAP, ptrack);
    end
    if pos(1) < size(Area,1)
        A.pos = [pos(1) + 1, pos(2), pos(3)];
        [List1, MAP] = decide_A(A, List1, MAP, ptrack);
    end
    if pos(2) > 1
        A.pos = [pos(1), pos(2) - 1, pos(3)];
        [List1, MAP] = decide_A(A, List1, MAP, ptrack);
    end
    if pos(2) < size(Area,2)
        A.pos = [pos(1), pos(2) + 1, pos(3)];
        [List1, MAP] = decide_A(A, List1, MAP, ptrack);
    end
    if pos(3) > 1
        A.pos = [pos(1), pos(2), pos(3) - 1];
        [List1, MAP] = decide_A(A, List1, MAP, ptrack);
    end
    if pos(3) < size(Area,3)
        A.pos = [pos(1), pos(2), pos(3) + 1];
        [List1, MAP] = decide_A(A, List1, MAP, ptrack);
    end
end
toc
disp('’TõŠ®—¹B')

function [List1, MAP] = decide_A(A, List1, MAP, ptrack)
    if ~ismember(sub2ind(size(Area), A.pos(1), A.pos(2), A.pos(3)), ptrack) && MAP(A.pos(1), A.pos(2), A.pos(3)) == 1
        A.g = pG + 0; %1;
        A.f = A.g + norm(End - A.pos);
        A.track = [ptrack, sub2ind(size(Area), A.pos(1), A.pos(2), A.pos(3))];
        MAP(A.pos(1), A.pos(2), A.pos(3)) = 0;
        List1 = [List1;A];
    end
end
%{
%% •ªŠòŒÀ’è–@‚É‚æ‚é’Tõ
List2.pos = Start;
List2.road = [];
List2.sum = 0;
List2.track = List2.pos(1) + size(matrix,1) * List2.pos(2);
minSumMatrix = minSum * ones(size(raw_matrix,1), size(raw_matrix,2));
while size(List2,2) > 0
    pos = List2(1).pos;
    pSum = List2(1).sum;
    proad = List2(1).road;
    ptrack = List2(1).track;
    List2(1) = [];
    if pos(1) == End(1) && pos(2) == End(2) && pSum <= minSum
        minSumMatrix(minSumMatrix == minSum) = pSum;
        minSum = pSum;
        ANS.sum = pSum;
        ANS.road = proad;
        ANS.track = ptrack;
    end
    if pos(1) > 1
        A2.pos = [pos(1) - 1, pos(2)];
        A2.sum = pSum + matrix(A2.pos(1), A2.pos(2));
        if A2.sum <= minSumMatrix(A2.pos(1), A2.pos(2)) && ~ismember(A2.pos(1) + size(matrix,1) * A2.pos(2), ptrack) && Area(A2.pos(1), A2.pos(2)) == 1
            minSumMatrix(A2.pos(1), A2.pos(2)) = A2.sum;
            A2.road = [proad, -1];
            A2.track = [ptrack, A2.pos(1) + size(matrix,1) * A2.pos(2)];
            List2 = [List2;A2];
        end
    end
    if pos(1) < size(matrix,1)
        A2.pos = [pos(1) + 1, pos(2)];
        A2.sum = pSum + matrix(A2.pos(1), A2.pos(2));
        if A2.sum <= minSumMatrix(A2.pos(1), A2.pos(2)) && ~ismember(A2.pos(1) + size(matrix,1) * A2.pos(2), ptrack) && Area(A2.pos(1), A2.pos(2)) == 1
            minSumMatrix(A2.pos(1), A2.pos(2)) = A2.sum;
            A2.road = [proad, 1];
            A2.track = [ptrack, A2.pos(1) + size(matrix,1) * A2.pos(2)];
            List2 = [List2;A2];
        end
    end
    if pos(2) > 1
        A2.pos = [pos(1), pos(2) - 1];
        A2.sum = pSum + matrix(A2.pos(1), A2.pos(2));
        if A2.sum <= minSumMatrix(A2.pos(1), A2.pos(2)) && ~ismember(A2.pos(1) + size(matrix,1) * A2.pos(2), ptrack) && Area(A2.pos(1), A2.pos(2)) == 1
            minSumMatrix(A2.pos(1), A2.pos(2)) = A2.sum;
            A2.road = [proad, -10];
            A2.track = [ptrack, A2.pos(1) + size(matrix,1) * A2.pos(2)];
            List2 = [List2;A2];
        end
    end
    if pos(2) < size(matrix,2)
        A2.pos = [pos(1), pos(2) + 1];
        A2.sum = pSum + matrix(A2.pos(1), A2.pos(2));
        if A2.sum <= minSumMatrix(A2.pos(1), A2.pos(2)) && ~ismember(A2.pos(1) + size(matrix,1) * A2.pos(2), ptrack) && Area(A2.pos(1), A2.pos(2)) == 1
            minSumMatrix(A2.pos(1), A2.pos(2)) = A2.sum;
            A2.road = [proad, 10];
            A2.track = [ptrack, A2.pos(1) + size(matrix,1) * A2.pos(2)];
            List2 = [List2;A2];
        end
    end
    T = struct2table(List2);
    [~, ia, ic] = unique(T.pos,'rows','stable');
    TMP = [];
    for i = 1:size(ia)
        B = List2(ic == i);
        T = struct2table(B);
        [~, id] = min(T.sum);
        TMP = [TMP;B(id)];
    end
    List2 =  TMP;
end

f = ANS;
toc
%}
end