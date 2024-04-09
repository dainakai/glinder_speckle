using XLSX
using FFTW
using Images
using StatsBase

xf = XLSX.readxlsx("Wheel_surface_GC120.xlsx")
sh = xf[2] # or 1
data = sh[2:end,2:end]#./500.0
m = mean(data)

function makelightdist(arr, mean, wavlen)
    lightdist = exp.(2im*pi*(arr .- mean)/wavlen)
    return lightdist
end

function transsqr(datlen, wavlen, dx)
    arr = zeros(Float32, (datlen, datlen))
    for i in 1:datlen
        for j in 1:datlen
            arr[j,i] = sqrt(1.0 - ((i-datlen/2)*wavlen/datlen/dx)^2 - ((j-datlen/2)*wavlen/datlen/dx)^2)
        end
    end
    return arr
end

function transfunc(z,arr, wavlen)
    trans = exp.(2im*pi*z/wavlen .* arr)
    return trans
end


datlen = 4096
wavlen = 0.6328
dx = 0.695515 #*2.0
h = size(data, 1)
w = size(data, 2)
obj = ones(ComplexF32, (datlen, datlen))
obj[datlen÷2-h÷2+1:datlen÷2+h÷2,datlen÷2-w÷2+1:datlen÷2+w÷2] .= makelightdist(data, m, wavlen)

sqr = transsqr(datlen, wavlen, dx)
z = 10000.0
trans = transfunc(z, sqr, wavlen)

holo = ifft(fftshift(fftshift(fft(obj)).*trans))
img = abs.(holo .* conj.(holo))
img = img ./ maximum(img)

save("holo.png", img)
