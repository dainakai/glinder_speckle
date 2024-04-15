using Plots
using Images
using Glob
using Statistics
using StatsBase

function loadholo(path)
    out = Float32.(channelview(Gray.(load(path))))
end

scenenum = '3'
pathlist = glob("./crop"*scenenum*"/*.png")
imgstack = loadholo.(pathlist)
imgstack = cat(imgstack..., dims=3)
aveimg = vec(mean(imgstack, dims=(1,2)))
sigmaimg = vec(std(imgstack, dims=(1,2)))
k = sigmaimg ./ aveimg

plot(aveimg, label="aveimg", xlabel="Frame Number", yrange=(0, 1.2), xrange=(0,170))
plot!(sigmaimg, label="sigmaimg")
plot!(k, label="k", legend=:outertopright)
savefig("stats_"*scenenum*".png")