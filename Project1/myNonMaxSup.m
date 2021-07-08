function img1 = myNonMaxSup(imgm, angle)
    imgm = padarray(imgm, [1, 1], 'replicate', 'both');
    al = [-1.0*pi,  7.0*pi;  1.0*pi, -7.0*pi; 3.0*pi, -5.0*pi; -3.0*pi, 5.0*pi; ] / 8.0;
    ar = [ 1.0*pi, -7.0*pi;  3.0*pi, -5.0*pi; 5.0*pi, -3.0*pi; -1.0*pi, 7.0*pi; ] / 8.0;
    img1 = imgm;
    s = size(angle);
    for dir = 1:4
        if dir == 1
            hpi = intersect(find(angle <= ar(dir,1)), find(angle >= al(dir, 1)));
            hpi_1 = union(find(angle <= ar(dir, 2)), find(angle >= al(dir, 2)));
        else
            hpi = intersect(find(angle <= ar(dir,1)), find(angle >= al(dir, 1)));
            hpi_1 = intersect(find(angle <= ar(dir, 2)), find(angle >= al(dir, 2)));
        end
        newHpi = union(hpi, hpi_1);
        [is, js] = ind2sub(s, newHpi);
        l = size(is);
        l = l(1);
        is = is+ 1;
        js = js + 1;
        for i = 1:l
            if dir == 1
                if imgm(is(i),js(i)) <= imgm(is(i),js(i)-1) || imgm(is(i), js(i)) <= imgm(is(i),js(i)+1)
                    img1(is(i), js(i)) = 0;
                end
            elseif dir == 2
                if imgm(is(i),js(i)) <= imgm(is(i)+1,js(i)+1) || imgm(is(i), js(i)) <= imgm(is(i)-1,js(i)-1)
                    img1(is(i), js(i)) = 0;
                end
            elseif dir == 3
                if imgm(is(i),js(i)) <= imgm(is(i)+1,js(i)) || imgm(is(i), js(i)) <= imgm(is(i)-1,js(i))
                    img1(is(i), js(i)) = 0;
                end
            else
                if imgm(is(i),js(i)) <= imgm(is(i)-1,js(i)+1) || imgm(is(i), js(i)) <= imgm(is(i)+1,js(i)-1)
                    img1(is(i), js(i)) = 0;
                end
            end
        end
    end
    img1 = img1(2:end-1, 2:end-1);
end