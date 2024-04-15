using Images
using Glob
using Plots
# 3 は x=170, y=64

function loadholo(path)
    out = Float32.(channelview(Gray.(load(path))))
end

scenenum = '4'
pathlist = glob("./20240410_"*scenenum*"/*.bmp")
imgstack = loadholo.(pathlist)
imgstack = cat(imgstack..., dims=3)
sumimg = sum(imgstack, dims=3)
# display(imgstack)
heatmap(sumimg[:,:,1])
gfimg = imfilter(sumimg[:,:,1], Kernel.gaussian(20))
heatmap(gfimg)
argmaxval = argmax(gfimg)

savedir = "crop" * scenenum
!isdir(savedir) && mkdir(savedir)
newimg = imgstack[argmaxval[1]-128+1:argmaxval[1]+128, argmaxval[2]-128+1:argmaxval[2]+128, :]
for (i, img) in enumerate(eachslice(newimg, dims=3))
    filename = lpad(i, 3, '0')
    save(joinpath(savedir, "$filename.png"), img)
end

