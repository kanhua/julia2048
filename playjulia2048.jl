using julia2048


## Please change the parameter here:
# Options of agents:
#     1. julia2048.humanPlayer : play it as a human
#     2. julia2048.randomAgent : agent that selects the next step randomly
#     3. julia2048.greedyAgent : agent that selects the next step that brings the highest score
#     4. julia2048.iterativeRandomAgent : monte carlo method to select the best next step
agent=julia2048.greedyAgent

# Set the number of trails
numberOfTrials=1

scores=zeros(numberOfTrials)
for i=1:length(scores)
	scores[i]=julia2048.gameLoop(agent)
end

# write the results of scores into this file
writedlm("result.txt",scores,',')

#p=plot(x=scores,Geom.histogram)
#draw(PNG("myplot.png", 12cm, 6cm), p)
