function  c = quantization(sigma, b)

x = -sigma*5:0.1:sigma*5;
y_norm = normpdf(x,0,sigma);

number_of_region = 2 ^ b;

% borders = linspace(-max(x), max(x), number_of_region+1);
borders = normrnd(0, sigma, [1,number_of_region + 1]);
borders = sort(borders);

for i = 1 : size(borders,2) - 1
    borders_samples(i) = (borders(i) + borders(i+1)) / 2;
end

borders(1) = -Inf;
borders(number_of_region+1) = Inf;


samples = normrnd(0, sigma, [1,number_of_region * 100]);
samples = [samples borders_samples];

% samples = linspace(-max(x), max(x), number_of_region*100);

c = zeros(1, number_of_region);
c_new = zeros(1, number_of_region);


while true

    for i = 1 : size(c,2)
        temp = [];
        temp = samples(samples > borders(i) & samples < borders(i+1));
        minimum = Inf;
        arg_min = Inf;
        for j = 1 : size(temp,2)
            arg_min = sum((temp(j)-temp).^2);
            if minimum > arg_min
                minimum = arg_min;
                c_new(i) = temp(j);
            end
        end
    end
    
    for i = 2 : size(borders,2) - 1
        borders(i) = (c_new(i-1) + c_new(i)) / 2;
    end
    
    if isequal(c_new, c) == 1
        break;
    else
        c = c_new;
    end
   
end


plot(x,y_norm)
title('Quantization')
xlabel('Observation')
ylabel('Probability Density')

y1=get(gca,'ylim');
for i = 2:range(size(borders))
    hold on
    p1 = plot([borders(i) borders(i)],y1, '-.', 'Color','blue');
end

for i = 1:range(size(c))+1
    hold on
    p2 = plot(c(i),0,'r*');
end
hold off
legend([p1 p2],{'Borders','Representatives'}, 'Location','northwest');

end

