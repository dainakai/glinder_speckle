using Plots
using Glob
using Images
using ProgressMeter
using StatsPlots

function loadholo(path)
    out = Float32.(channelview(Gray.(load(path))))
end

# img = loadholo("./crop3/001.png")
# histogram(vec(img).*255, bins=256, title="histogram")

scenenum = '4'
savedir = "histogram_"*scenenum
!isdir(savedir) && mkdir(savedir)
pathlist = glob("./crop"*scenenum*"/*.png")
@showprogress for path in pathlist
    img = loadholo(path)
    histogram(vec(img).*255, bins=256, legend=false, xlabel="intensity", ylabel="frequency #", xrange=(0, 255), yrange=(0, 7000), color=:black)
    savefig(joinpath(savedir, basename(path)))
end