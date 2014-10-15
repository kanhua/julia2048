using julia2048

#using Gadfly

numberOfTrials=1
scores=zeros(numberOfTrials)
for i=1:length(scores)
	scores[i]=julia2048.gameLoop(julia2048.iterativeRandomAgent2)
end


writedlm("result3.txt",scores,',')
#p=plot(x=scores,Geom.histogram)
#draw(PNG("myplot.png", 12cm, 6cm), p)
Profile.print(format=:flat)