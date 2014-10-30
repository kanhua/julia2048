using Gadfly

scores=readdlm("result.txt")


p=plot(x=scores,Geom.histogram,Guide.xlabel("score"),Guide.ylabel("occurences"))
draw(PNG("myplot.png", 30cm, 15cm), p)
