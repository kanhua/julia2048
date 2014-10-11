using julia2048

#using Gadfly

numberOfTrials=10
scores=zeros(numberOfTrials)
for i=1:length(scores)
	scores[i]=julia2048.gameLoop(julia2048.iterativeRandomAgent)
end


writedlm("result.txt",scores,',')
#p=plot(x=scores,Geom.histogram)
#draw(PNG("myplot.png", 12cm, 6cm), p)