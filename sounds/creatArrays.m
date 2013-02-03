function createAlternateArray(n,totalLength)
    return repmat([zeros(1,n) ones(1,n)],1,totalLength/n); 
end 