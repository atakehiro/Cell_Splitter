function ASTAR = find_shortest_path_6direction(Area, Start, End)
tic
disp('2“_‚ðŒ‹‚Ôü‚ð’Tõ‚µ‚Ü‚·B')
%% A*ƒAƒ‹ƒSƒŠƒYƒ€‚Å’Tõ
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
        A.g = pG + 1; %0;
        A.f = A.g + sum(abs(End - A.pos));%norm(End - A.pos);
        A.track = [ptrack, sub2ind(size(Area), A.pos(1), A.pos(2), A.pos(3))];
        MAP(A.pos(1), A.pos(2), A.pos(3)) = 0;
        List1 = [List1;A];
    end
end
end