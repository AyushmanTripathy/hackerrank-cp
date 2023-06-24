# non-divisible-subset


```cpp
int nonDivisibleSubset(int k, vector<int> s) {
    vector<int> count(k);
    int result=0;
    for(int i=0;i<s.size();i++){
        count[s[i]%k]++;
    }
    for(int i=0;i<=k/2;i++){
        if(i==(k-i)%k)  result += min(count[i],1);
        else result += max(count[i],count[k-i]);
    }
    return result;
}
```

notice the `i == (k - i) % k` condition, satisfed by

1. 0
1. middle element 
