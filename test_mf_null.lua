-- test

mf_null = {
   type     = 35 ;
   filename =  "/dev/null";
   append   = true  ;          -- so , logicals are allowed
}

function getTableSize(t)
    local count = 0
    for index, value in pairs(t) do
       print(index,':',value)
        count = count + 1
    end
    return count
end

print("emoe: size=",getTableSize(mf_null));
print("mf_null.append = ",mf_null.append)
print("mf_null.type   = ",mf_null.type  )
