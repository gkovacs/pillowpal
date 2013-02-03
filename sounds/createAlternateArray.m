function yCreate = createAlternateArray(n,totalLength)
    reps = totalLength/n; 
    yCreate = repmat([zeros(1,n) ones(1,n)],1,reps); 
end