using LinearAlgebra
using DelimitedFiles
include("readclassjson.jl")

data = readclassjson("HW8\\tomo_data.json")
N = data["N"]
npixels = data["npixels"]
y = data["y"]
line_pixel_lengths = data["line_pixel_lengths"]

A = line_pixel_lengths'
x = A\y
x = reshape(x, npixels, npixels)
heatmap(x, yflip=true, aspect_ratio=:equal, color=:gist_gray,
 cbar=:none, framestyle=:none)
